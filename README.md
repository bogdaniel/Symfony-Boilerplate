We recommend using composer with Composer with [prestissimo](https://github.com/hirak/prestissimo)

The boilerplate comes bundles with a few features that will speed up initial development.

apache-pack - This pack installs a `.htaccess` file in the `public/` directory that contains the rewrite rules.
> A performance improvement can be achieved by moving the rewrite rules
> from the `.htaccess` file into the VirtualHost block of your Apache
> configuration and then changing `AllowOverride All` to `AllowOverride
> None` in your VirtualHost block.


Use the following **optimized configuration** to disable `.htaccess` support and increase web server performance:

    <VirtualHost *:80>
        ServerName domain.tld
        ServerAlias www.domain.tld
    
        DocumentRoot /var/www/project/public
        DirectoryIndex /index.php
    
        <Directory /var/www/project/public>
            AllowOverride None
            Order Allow,Deny
            Allow from All
    
            FallbackResource /index.php
        </Directory>
    
        # uncomment the following lines if you install assets as symlinks
        # or run into problems when compiling LESS/Sass/CoffeeScript assets
        # <Directory /var/www/project>
        #     Options FollowSymlinks
        # </Directory>
    
        # optionally disable the fallback resource for the asset directories
        # which will allow Apache to return a 404 error when files are
        # not found instead of passing the request to Symfony
        <Directory /var/www/project/public/bundles>
            FallbackResource disabled
        </Directory>
        ErrorLog /var/log/apache2/project_error.log
        CustomLog /var/log/apache2/project_access.log combined
    
        # optionally set the value of the environment variables used in the application
        #SetEnv APP_ENV prod
        #SetEnv APP_SECRET <app-secret-id>
        #SetEnv DATABASE_URL "mysql://db_user:db_pass@host:3306/db_name"
    </VirtualHost>

> Use `FallbackResource` on Apache 2.4.25 or higher, due to a bug which
> was fixed on that release causing the root `/` to hang.

More info about the configuration you can find here  [# Symfony Configuring a Web Server](https://symfony.com/doc/current/setup/web_server_configuration.html)


### PHP analysis tools
Let's begin with [PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer):

> PHP_CodeSniffer is a set of two PHP scripts; the main phpcs script
> that tokenizes PHP, JavaScript and CSS files to detect violations of a
> defined coding standard, and a second phpcbf script to automatically
> correct coding standard violations. PHP_CodeSniffer is an essential
> development tool that ensures your code remains clean and consistent.
> 
> -- GitHub

A cool feature of PHPStan is its ability to use plugins (for additional rules).

And guess what, I know some of them which are useful!

First, [TheCodingMachine strict rules](https://github.com/thecodingmachine/phpstan-strict-rules) (see our [blog post](https://thecodingmachine.io/type-hint-all-the-things) for more details):
