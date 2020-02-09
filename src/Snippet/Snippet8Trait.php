<?php


namespace App\Snippet;

use RuntimeException;
use Symfony\Component\HttpKernel\KernelInterface;
use Symfony\Component\Process\Process;

/**
 * I am using a PHP trait in order to isolate each snippet in a file.
 * This code should be called from a Symfony controller extending AbstractController (as of Sf 4.2)
 * or Symfony\Bundle\FrameworkBundle\Controller\Controller (Sf <= 4.1)
 * Services are injected in the controller constructor.
 *
 * @see https://symfony.com/doc/current/components/process.html
 */
trait Snippet8Trait
{
    protected $kernel;

    public function __construct(KernelInterface $kernel)
    {
        $this->kernel = $kernel;
    }

    public function snippet8()
    {
        if (!$this->kernel instanceof KernelInterface) {
            throw new RuntimeException("Houston, We've Got a Problem. 💥");
        }

        $process = new Process([
            'make',
            '-f',
            $this->kernel->getProjectDir() . '/Makefile',
        ]);
        $process->run();

        $output = str_replace(
            ["\e[33m", "\e[32m", "\e[0m"],
            '',
            $process->getOutput()
        );

        echo $output; // That's it! 😁
    }
}