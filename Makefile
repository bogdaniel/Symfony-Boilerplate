# —— Inspired by ———————————————————————————————————————————————————————————————
# https://speakerdeck.com/mykiwi/outils-pour-ameliorer-la-vie-des-developpeurs-symfony?slide=47
# https://blog.theodo.fr/2018/05/why-you-need-a-makefile-on-your-project/

# Setup —————————————————————————————————————————————————————————————————————————
PROJECT  = strangebuzz
EXEC_PHP = php
REDIS    = redis-cli
SYMFONY  = $(EXEC_PHP) bin/console
COMPOSER = $(EXEC_PHP) composer.phar
.DEFAULT_GOAL := help

## —— 🐝  Strangebuzz Make file  🐝  —————————————————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Composer —————————————————————————————————————————————————————————————————
install: composer.lock ## Install vendors according to the current composer.lock file
	$(COMPOSER) install

update: composer.json ## Update vendors according to the current composer.json file
	$(COMPOSER) update

check: ## Check dependencies
	php vendor/bin/composer-require-checker check composer.json

## —— Symfony ——————————————————————————————————————————————————————————————————
sf: ## List Symfony commands
	$(SYMFONY)

cc: ## Clear cache
	$(SYMFONY) c:c

warmup: ## Warmump the cache
	$(SYMFONY) cache:warmup

fix-perms: ## Fix permissions of all var files
	chmod -R 777 var/*

start: ## Start the local Symfony web server
	$(SYMFONY) server:start

stop: ## Stop the local Symfony web server
	$(SYMFONY) server:stop

assets: ## Install the assets with symlinks in the public folder (web)
	$(SYMFONY) assets:install web/ --symlink  --relative

purge: ## Purge cache and logs
	rm -rf var/cache/* var/logs/*

## —— Project ——————————————————————————————————————————————————————————————————
cc-redis: ## Flush all Redis cache
	$(REDIS) flushall

commands: ## Display all Strangebuzz specific commands
	$(SYMFONY) list $(PROJECT)

load-fixtures: ## Build the db, control the schema validity, load fixtures and check the migration status
	$(SYMFONY) doctrine:cache:clear-metadata
	$(SYMFONY) doctrine:database:create --if-not-exists
	$(SYMFONY) doctrine:schema:drop --force
	$(SYMFONY) doctrine:schema:create
	$(SYMFONY) doctrine:schema:validate
	$(SYMFONY) doctrine:fixtures:load -n
	$(SYMFONY) doctrine:migration:status

cs: ## Launch check style and static analysis
	./vendor/squizlabs/php_codesniffer/bin/phpcs --config-set colors 1 --standard=phpcs.xml --report-diff=changes.diff -n -p src/
	./vendor/squizlabs/php_codesniffer/bin/phpcbf --config-set colors 1 --standard=phpcs.xml -w -p src/
	./vendor/bin/phpstan analyse src -c phpstan.neon --level=7 --no-progress -vvv --memory-limit=1024M

test: phpunit.xml.dist load-fixtures ## Launch all functionnal and unit tests
	bin/phpunit --stop-on-failure

## —— Deploy ——————————————————————————————————————————————————————————————————
deploy: ## Deploy, install composer dependencies and run database migrations
	bin/prod/deploy.sh

git-update: ## Update Git only and refresh cache (sf+pagespeed)
	git pull
	rm -rf var/cache/* var/logs/*
	php bin/console cache:warmup
	chmod -R 777 var/*
	touch /var/cache/mod_pagespeed/cache.flush