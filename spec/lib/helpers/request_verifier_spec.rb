require 'rails_helper'

RSpec.describe Alexa::RequestVerifier do


  describe ".verify" do

    let(:body) do
      { 'session' => {
          'sessionId' => 'SessionId.b4470d1c-67a0-4da2-98c7-853acead6773',
          'application' => {
            'applicationId' => 'amzn1.ask.skill.057ceea6-1e3a-4edb-9a4f-f962f8cc0cac'
          },
          'attributes' => {},
          'user' => {
            'userId' => 'amzn1.ask.account.AEP3BKUW344CTHKJDR6P33Y2RJZL6AOSIIWPAEE23O6AIUHMLQ7VSG7NE2CHPDDDCMKF57M43ULCPZLG2U2CIN5NG7MWT6KCDVQS2PXDM5HQYN5J7A26JFPOT7E56W5NQ6S3GSDNINQQZEL5EHDFSXFBM3ST3M5CMK53IZHHQMBCYDA2EFD6OJL7HE6I7WGLSHSLMTN5I7YQDVQ',
            'accessToken' => nil
          },
          'new' => false,
          'request' => {
            'requestId' => 'EdwRequestId.9eaad9b4-48f7-4f6e-8ee9-42a4d7691d4e',
            'locale' => 'en-US',
            'type' => 'IntentRequest',
            'timestamp' => Time.now.to_i,
            'intent' => {
              'name' => 'Warning',
              'slots' => {}
            }
          },
          'context' => {
            'System' => {
              'application' => {
                'applicationId' => 'applicationId'
              },
              'user' => {
                'userId' => 'userId',
                'permissions' => {
                  'consentToken' => 'consentToken'
                },
                'accessToken' => 'accessToken'
              },
              'device' => {
                'deviceId' => 'deviceId',
                'supportedInterfaces' => {}
              },
              'apiEndpoint' => 'apiEndpoint'
            }
          }
        }
      }
    end

    let(:signature) do
      "PGJpiD4Ex+3yha3u2e5NOOad6icEu4kv7oE/mTjHrxcXqsm58ESvBa5XtvRlBLHZXKb2oAFavTjKN1GAOz2vohw/Y+g2OIUdptLl6dTTQKFRrc8Wty/6+eKxYJ014nNnwYvT6YB9komGN4nxnTUiKSXLtxIpZynjyXAqP9cMV7su4OQcocT5fp5gs0ZQM+CHasLeGAUQdgU67HOdQ3XA+/U3Lrorr0x1e3YWidkogNxAA0dhpIDQbWuDNHSxoGBPUuCjOs/vOBrckH15yBoUd1CU3FTzDzCeF/soqnC3V1brCZhCbxh7kd3JUhj5YOLJyqcQ93pzO4ZPcJiX1R0fNw=="
    end

    let(:response) do
      double('HTTP:Response', code: '200', body: 'Sample Body')
    end

    let(:http) do
      double('Net::HTTP', :use_ssl= => true, :verify_mode= => true, start: true, request: response, finish: true)
    end

    let(:certificate) do
      double('OpenSSL::X509::Certificate', public_key: public_key)
    end

    let(:request) do
      OpenStruct.new(
        body: StringIO.new(body['session'].to_json),
        headers: {
          'SignatureCertChainUrl' => url,
          'Signature' => signature
        }
      )
    end

    context "Gets a request that originates from Alexa" do

      let(:url) do
        "https://s3.amazonaws.com/echo.api/echo-api-cert-4.pem"
      end

      let(:public_key) do
        double('PublicKey', verify: true)
      end

      before do
        allow(Net::HTTP).to receive(:new).and_return(http)
        allow(OpenSSL::X509::Certificate).to receive(:new).and_return(certificate)
      end

      context "With a Timestamp inside the appropriate window" do

        let(:body) do
          { 'session' => {
              'sessionId' => 'SessionId.b4470d1c-67a0-4da2-98c7-853acead6773',
              'application' => {
                'applicationId' => 'amzn1.ask.skill.057ceea6-1e3a-4edb-9a4f-f962f8cc0cac'
              },
              'attributes' => {},
              'user' => {
                'userId' => 'amzn1.ask.account.AEP3BKUW344CTHKJDR6P33Y2RJZL6AOSIIWPAEE23O6AIUHMLQ7VSG7NE2CHPDDDCMKF57M43ULCPZLG2U2CIN5NG7MWT6KCDVQS2PXDM5HQYN5J7A26JFPOT7E56W5NQ6S3GSDNINQQZEL5EHDFSXFBM3ST3M5CMK53IZHHQMBCYDA2EFD6OJL7HE6I7WGLSHSLMTN5I7YQDVQ',
                'accessToken' => nil
              },
              'new' => false,
              'request' => {
                'requestId' => 'EdwRequestId.9eaad9b4-48f7-4f6e-8ee9-42a4d7691d4e',
                'locale' => 'en-US',
                'type' => 'IntentRequest',
                'timestamp' => Time.now.to_i,
                'intent' => {
                  'name' => 'Warning',
                  'slots' => {}
                }
              },
              'context' => {
                'System' => {
                  'application' => {
                    'applicationId' => 'applicationId'
                  },
                  'user' => {
                    'userId' => 'userId',
                    'permissions' => {
                      'consentToken' => 'consentToken'
                    },
                    'accessToken' => 'accessToken'
                  },
                  'device' => {
                    'deviceId' => 'deviceId',
                    'supportedInterfaces' => {}
                  },
                  'apiEndpoint' => 'apiEndpoint'
                }
              }
            }
          }
        end

        it "returns true for a correctly formatted Alexa Request" do
          verifier = Alexa::RequestVerifier.new(request)
          expect(verifier.verify).to eql nil
        end

      end

      context "With a Timestamp outside the appropriate window" do

        let(:body) do
          { 'session' => {
              'sessionId' => 'SessionId.b4470d1c-67a0-4da2-98c7-853acead6773',
              'application' => {
                'applicationId' => 'amzn1.ask.skill.057ceea6-1e3a-4edb-9a4f-f962f8cc0cac'
              },
              'attributes' => {},
              'user' => {
                'userId' => 'amzn1.ask.account.AEP3BKUW344CTHKJDR6P33Y2RJZL6AOSIIWPAEE23O6AIUHMLQ7VSG7NE2CHPDDDCMKF57M43ULCPZLG2U2CIN5NG7MWT6KCDVQS2PXDM5HQYN5J7A26JFPOT7E56W5NQ6S3GSDNINQQZEL5EHDFSXFBM3ST3M5CMK53IZHHQMBCYDA2EFD6OJL7HE6I7WGLSHSLMTN5I7YQDVQ',
                'accessToken' => nil
              },
              'new' => false,
              'request' => {
                'requestId' => 'EdwRequestId.9eaad9b4-48f7-4f6e-8ee9-42a4d7691d4e',
                'locale' => 'en-US',
                'type' => 'IntentRequest',
                'timestamp' => (Time.now - 1600).to_i,
                'intent' => {
                  'name' => 'Warning',
                  'slots' => {}
                }
              },
              'context' => {
                'System' => {
                  'application' => {
                    'applicationId' => 'applicationId'
                  },
                  'user' => {
                    'userId' => 'userId',
                    'permissions' => {
                      'consentToken' => 'consentToken'
                    },
                    'accessToken' => 'accessToken'
                  },
                  'device' => {
                    'deviceId' => 'deviceId',
                    'supportedInterfaces' => {}
                  },
                  'apiEndpoint' => 'apiEndpoint'
                }
              }
            }
          }
        end

        it "returns true for a correctly formatted Alexa Request" do
          verifier = Alexa::RequestVerifier.new(request)
          expect{verifier.verify}.to raise_error Alexa::VerificationError
        end

      end

    end

    context "Gets a request that does not originate from Alexa" do

      let(:body) do
        { 'session' => {
            'sessionId' => 'SessionId.b4470d1c-67a0-4da2-98c7-853acead6773',
            'application' => {
              'applicationId' => 'amzn1.ask.skill.057ceea6-1e3a-4edb-9a4f-f962f8cc0cac'
            },
            'attributes' => {},
            'user' => {
              'userId' => 'amzn1.ask.account.AEP3BKUW344CTHKJDR6P33Y2RJZL6AOSIIWPAEE23O6AIUHMLQ7VSG7NE2CHPDDDCMKF57M43ULCPZLG2U2CIN5NG7MWT6KCDVQS2PXDM5HQYN5J7A26JFPOT7E56W5NQ6S3GSDNINQQZEL5EHDFSXFBM3ST3M5CMK53IZHHQMBCYDA2EFD6OJL7HE6I7WGLSHSLMTN5I7YQDVQ',
              'accessToken' => nil
            },
            'new' => false,
            'request' => {
              'requestId' => 'EdwRequestId.9eaad9b4-48f7-4f6e-8ee9-42a4d7691d4e',
              'locale' => 'en-US',
              'type' => 'IntentRequest',
              'timestamp' => Time.now.to_i,
              'intent' => {
                'name' => 'Warning',
                'slots' => {}
              }
            },
            'context' => {
              'System' => {
                'application' => {
                  'applicationId' => 'applicationId'
                },
                'user' => {
                  'userId' => 'userId',
                  'permissions' => {
                    'consentToken' => 'consentToken'
                  },
                  'accessToken' => 'accessToken'
                },
                'device' => {
                  'deviceId' => 'deviceId',
                  'supportedInterfaces' => {}
                },
                'apiEndpoint' => 'apiEndpoint'
              }
            }
          }
        }
      end

      context "With an incorrect SignatureCertChainUrl" do

        let(:url) do
          "https://s3.fakeamazonaws.com/echo.api/echo-api-cert-4.pem"
        end

        let(:public_key) do
          double('PublicKey', verify: true)
        end

        before do
          allow(Net::HTTP).to receive(:new).and_return(http)
          allow(OpenSSL::X509::Certificate).to receive(:new).and_return(certificate)
        end

        it "returns false for a correctly formatted Alexa Request" do
          verifier = Alexa::RequestVerifier.new(request)
          expect{verifier.verify}.to raise_error Alexa::VerificationError
        end

      end

      context "With a proper SignatureCertChainUrl" do

        let(:url) do
          "https://s3.amazonaws.com/echo.api/echo-api-cert-4.pem"
        end

        let(:public_key) do
          double('PublicKey', verify: false)
        end

        before do
          allow(Net::HTTP).to receive(:new).and_return(http)
          allow(OpenSSL::X509::Certificate).to receive(:new).and_return(certificate)
        end

        it "returns false for a correctly formatted Alexa Request" do
          verifier = Alexa::RequestVerifier.new(request)
          expect{verifier.verify}.to raise_error Alexa::VerificationError
        end

      end

    end

  end

end
