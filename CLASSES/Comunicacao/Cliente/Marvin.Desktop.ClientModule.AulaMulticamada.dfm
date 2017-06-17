object ClientModuleAulaMulticamada: TClientModuleAulaMulticamada
  OldCreateOrder = False
  Height = 271
  Width = 415
  object RESTClient: TRESTClient
    Accept = 'application/json;q=0.9,text/plain;q=0.9,text/html'
    AcceptCharset = 'UTF-8'
    Params = <>
    HandleRedirects = True
    RaiseExceptionOn500 = False
    Left = 192
    Top = 24
  end
  object RESTRequest: TRESTRequest
    Accept = 'application/json;q=0.9,text/plain;q=0.9,text/html'
    AcceptCharset = 'UTF-8'
    Client = RESTClient
    Params = <>
    Response = RESTResponse
    Timeout = 0
    SynchronizedEvents = False
    Left = 88
    Top = 88
  end
  object RESTResponse: TRESTResponse
    Left = 264
    Top = 88
  end
end
