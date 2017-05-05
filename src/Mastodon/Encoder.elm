module Mastodon.Encoder
    exposing
        ( encodeUrl
        , appRegistrationEncoder
        , authorizationCodeEncoder
        , clientEncoder
        , registrationEncoder
        , statusRequestBodyEncoder
        )

import Http
import Json.Encode as Encode
import Mastodon.Model exposing (..)


encodeMaybe : (a -> Encode.Value) -> Maybe a -> Encode.Value
encodeMaybe encode thing =
    case thing of
        Nothing ->
            Encode.null

        Just value ->
            encode value


encodeUrl : String -> List ( String, String ) -> String
encodeUrl base params =
    List.map (\( k, v ) -> k ++ "=" ++ Http.encodeUri v) params
        |> String.join "&"
        |> (++) (base ++ "?")


appRegistrationEncoder : String -> String -> String -> String -> Encode.Value
appRegistrationEncoder client_name redirect_uris scope website =
    Encode.object
        [ ( "client_name", Encode.string client_name )
        , ( "redirect_uris", Encode.string redirect_uris )
        , ( "scopes", Encode.string scope )
        , ( "website", Encode.string website )
        ]


authorizationCodeEncoder : AppRegistration -> String -> Encode.Value
authorizationCodeEncoder registration authCode =
    Encode.object
        [ ( "client_id", Encode.string registration.client_id )
        , ( "client_secret", Encode.string registration.client_secret )
        , ( "grant_type", Encode.string "authorization_code" )
        , ( "redirect_uri", Encode.string registration.redirect_uri )
        , ( "code", Encode.string authCode )
        ]


clientEncoder : Client -> Encode.Value
clientEncoder client =
    Encode.object
        [ ( "server", Encode.string client.server )
        , ( "token", Encode.string client.token )
        ]


registrationEncoder : AppRegistration -> Encode.Value
registrationEncoder registration =
    Encode.object
        [ ( "server", Encode.string registration.server )
        , ( "scope", Encode.string registration.scope )
        , ( "client_id", Encode.string registration.client_id )
        , ( "client_secret", Encode.string registration.client_secret )
        , ( "id", Encode.int registration.id )
        , ( "redirect_uri", Encode.string registration.redirect_uri )
        ]


statusRequestBodyEncoder : StatusRequestBody -> Encode.Value
statusRequestBodyEncoder statusData =
    Encode.object
        [ ( "status", Encode.string statusData.status )
        , ( "in_reply_to_id", encodeMaybe Encode.int statusData.in_reply_to_id )
        , ( "spoiler_text", encodeMaybe Encode.string statusData.spoiler_text )
        , ( "sensitive", Encode.bool statusData.sensitive )
        , ( "visibility", Encode.string statusData.visibility )
        ]