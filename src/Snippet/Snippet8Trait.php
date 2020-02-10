<?php declare(strict_types=1);

namespace App\Snippet;

use Symfony\Component\HttpKernel\KernelInterface;
use Symfony\Component\Process\Process;

/**
 * I am using a PHP trait in order to isolate each snippet in a file.
 * This code should be called from a Symfony controller extending AbstractController (as of Symfony 4.2)
 * or Symfony\Bundle\FrameworkBundle\Controller\Controller (Symfony <= 4.1).
 * Services are injected in the main controller constructor.
 *
 * @property KernelInterface $kernel
 */
trait Snippet8Trait
{
    public function snippet8(): void
    {
        $process = new Process([
            'make',
            '-f',
            $this->kernel->getProjectDir().'/Makefile',
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