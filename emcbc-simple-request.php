<?php

$connect = "https://emccoinrpc:aevae9ooyahjaezu7Zou6eingie3ivoo9cei5iquaive8fohp4IeY5oa8fiHaisa@localhost:6662'";
$method  = "name_show";
$params  = [ 'ssh:sv' ];

$request = json_encode ( [ 'method' => $method, 'params' => $params, ], JSON_UNESCAPED_UNICODE );

$opts = [
            'http' => [
                'method' => 'POST',
                'header' => join(
                    "\r\n",
                    [
                        'Content-Type: application/json; charset=utf-8',
                        'Accept-Charset: utf-8;q=0.7,*;q=0.7',
                    ]
                ),
                'content' => $request,
                'ignore_errors' => true,
                'timeout' => 10,
            ],
            'ssl' => [
                "verify_peer" => false,
                "verify_peer_name" => false,
            ],
];

$response = @file_get_contents($connect, false, stream_context_create($opts));
$rc = json_decode($response, true);

var_dump ($rc);
print "\n";

