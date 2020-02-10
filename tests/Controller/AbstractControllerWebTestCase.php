<?php
declare(strict_types=1);

namespace App\Tests\Controller;


use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;
use Symfony\Bundle\FrameworkBundle\KernelBrowser;
use Symfony\Component\HttpFoundation\Response;

abstract class AbstractControllerWebTestCase extends WebTestCase
{
    /** @var KernelBrowser */
    protected $client;

    protected function setUp(): void
    {
        self::bootKernel();
        $this->client = static::createClient();
    }

    /**
     * @param mixed[] $data
     *
     * @throws JsonException
     */
    protected function JSONRequest(string $method, string $uri, array $data = []): void
    {
        $this->client->request($method, $uri, [], [], ['CONTENT_TYPE' => 'application/json'], json_encode($data));
    }

    /**
     * @param Response $response
     * @param int $expectedStatusCode
     * @return mixed
     *
     */
    protected function assertJSONResponse(Response $response, int $expectedStatusCode)
    {
        $this->assertEquals($expectedStatusCode, $response->getStatusCode());
        $this->assertTrue($response->headers->contains('Content-Type', 'application/json'));
        $this->assertJson($response->getContent());

        return json_decode($response->getContent(), true);
    }
}