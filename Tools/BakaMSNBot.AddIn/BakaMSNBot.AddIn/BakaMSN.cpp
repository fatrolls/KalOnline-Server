#pragma once

using namespace System ;
using namespace Microsoft::Messenger;

int incoming_messages;
int outcoming_messages;

namespace BakaMSNBot {

public ref class AddIn : IMessengerAddIn
{
MessengerClient^ m_client ;

virtual void Initialize(MessengerClient^ client) sealed = Microsoft::Messenger::IMessengerAddIn::Initialize
{
	m_client = client;
	// Set a couple properties for this add-in
	m_client->AddInProperties->FriendlyName = "BakaMSNBot";
	// Subscribe to the incoming text message event.

	m_client->IncomingTextMessage += gcnew EventHandler<IncomingTextMessageEventArgs ^>(this, &BakaMSNBot::AddIn::OnIncomingMessage);

	m_client->OutgoingTextMessage += gcnew EventHandler<OutgoingTextMessageEventArgs ^>(this, &BakaMSNBot::AddIn::OutgoingTextMessage);
}

public:
void OnIncomingMessage(System::Object^ sender, IncomingTextMessageEventArgs^ args)
{
    incoming_messages++;
     //MSN BOT GET A MESSAGE
	if ((args->TextMessage->ToLower() == "hey")
		|| (args->TextMessage->ToLower() == "hi")
		|| (args->TextMessage->ToLower() == "hello")
		|| (args->TextMessage->ToLower() == "hallo"))
	{
		m_client->SendTextMessage("\nBakaMSNBot:\n  Dear " + args->UserFrom->FriendlyName +",  i really work much on my pc..\n  So it can need really long until I answer !\n   So wait ! THX \n   /info for more BOT Commands",args->UserFrom);	
	}
	if (args->TextMessage->ToLower() == "/info")
	{
		//some info
		m_client->SendTextMessage("\nBakaMSNBot:\n  My homepage: http://bakabug.blogspot.com\n  Since this session i got "+incoming_messages+" messages\n  BakaBug sent "+outcoming_messages+" messages",args->UserFrom);
	}
}

void OutgoingTextMessage(System::Object^ sender, OutgoingTextMessageEventArgs^ args)
{
	outcoming_messages++;
     //MSN BOT GET A MESSAGE FROM ME
	if (args->TextMessage->ToLower() == "hey")
	{
		
	}
}

};

}