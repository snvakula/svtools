<?php

CONST CLIENT_ID = '__YOUR_CLIENT_ID__';
CONST CLIENT_SECRET = '__YOUR_CLIENT_SECRET__';
CONST AUTH_PAGE = 'https://id.emercoin.net/oauth/v2/auth';
CONST AUTH_TOKEN = 'https://id.emercoin.net/oauth/v2/token';
CONST INFOCARD_PAGE = 'https://id.emercoin.net/infocard';
CONST REDIRECT_URI = 'https://demoapp.aspanta.com/emcid-client/emcid-client.php';


if (!(array_key_exists('error', $_REQUEST) || array_key_exists('code', $_REQUEST))) {
    $auth = AUTH_PAGE;
    $authQ = http_build_query(
        [
            'client_id' => CLIENT_ID,
            'redirect_uri' => REDIRECT_URI,
            'response_type' => 'code',
        ]
    );

    header('Location: '.$auth.'?'.$authQ);
}

if (array_key_exists('code', $_REQUEST) && array_key_exists('state', $_REQUEST) && !array_key_exists(
        'error',
        $_REQUEST
    )
) {
    $connect = AUTH_TOKEN;

    $opts = [
        'http' => [
            'method' => 'POST',
            'header' => join(
                "\r\n",
                [
                    'Content-Type: application/x-www-form-urlencoded; charset=utf-8',
                    'Accept-Charset: utf-8;q=0.7,*;q=0.7',
                ]
            ),
            'content' => http_build_query(
                [
                    'code' => $_REQUEST['code'],
                    'client_id' => CLIENT_ID,
                    'client_secret' => CLIENT_SECRET,
                    'grant_type' => 'authorization_code',
                    'redirect_uri' => REDIRECT_URI,
                ]
            ),
            'ignore_errors' => true,
            'timeout' => 10,
        ],
        'ssl' => [
            "verify_peer" => false,
            "verify_peer_name" => false,
        ],
    ];


    $response = @file_get_contents($connect, false, stream_context_create($opts));
    $response = json_decode($response, true);

    if (!array_key_exists('error', $response)) {
        $infocard_url = INFOCARD_PAGE;
        $infocard_url .= '/'.$response['access_token'];
        $opts = [
            'http' => [
                'method' => 'GET',
                'ignore_errors' => true,
                'timeout' => 10,
            ],
            'ssl' => [
                "verify_peer" => false,
                "verify_peer_name" => false,
            ],
        ];
        $info = @file_get_contents($infocard_url, false, stream_context_create($opts));
        echo '<pre>';
        echo 'Authorized'."\r\n";
        var_dump($response);
        echo 'InfoCard'."\r\n";
        var_dump(json_decode($info, true));
        echo '</pre>';
    } else {
        echo '<pre>';
        echo($response['error_description']);
        echo '</pre>';
    }

} else {
    echo '<pre>';
    echo $_REQUEST['error_description'];
    echo '</pre>';
}
