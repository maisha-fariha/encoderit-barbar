/// When `false`, login/register use the HTTP [AuthService] against [AppConfig.apiBaseUrl]
/// (JWT/session parsing stays in the data layer). Set to `false` as soon as your API is ready.
const bool kUseLocalAuthBackend = true;
