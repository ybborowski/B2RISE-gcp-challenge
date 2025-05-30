import * as express from 'express';
import { Express } from 'express';
import { Request, Response } from 'express-serve-static-core';
import { Message, PubSub, Subscription } from '@google-cloud/pubsub';
import { MessageOptions } from '@google-cloud/pubsub/build/src/topic';


const app: Express = express();
const port = 80;

app.get( '/', ( req: Request, res: Response ) => {
  res.send( 'Olá do GCP com TypeScript e Express!' );
} );

app.listen( port, () => {
  console.log( `API rodando na porta ${ port }` );
} );

const pubsub = new PubSub();

app.get( '/consume', async ( req: Request, res: Response ) => {
  try {
    const subscriptionName = process.env.PUBSUB_SUBSCRIPTION || 'api-subscription';
    const subscription: Subscription = pubsub.subscription( subscriptionName );

    let messageReceived = '';

    const messageHandler = ( message: Message ) => {
      messageReceived = message.data.toString();
      console.log( `Mensagem recebida: ${ messageReceived }` );
      message.ack();
      subscription.removeListener( 'message', messageHandler );
      res.send( `Mensagem: ${ messageReceived }` );
    };

    subscription.on( 'message', messageHandler );

    // Timeout para encerrar se não houver mensagem
    setTimeout( () => {
      subscription.removeListener( 'message', messageHandler );
      if ( !messageReceived ) {
        res.send( 'Nenhuma mensagem recebida.' );
      }
    }, 5000 );
  } catch ( err ) {
    console.error( err );
    res.status( 500 ).send( 'Erro ao consumir mensagem' );
  }
} );

app.get( '/produce', async ( req: Request, res: Response ) => {
  try {
    const topicName = process.env.PUBSUB_TOPIC || 'api-topic';
    const data = (req.query.message || '')?.toString() || 'Olá do endpoint /produce!';

    const message: MessageOptions = {
      data: Buffer.from( data ),
    };
    const messageId = await pubsub.topic( topicName ).publishMessage( message );

    console.log( `Mensagem publicada com ID: ${ messageId }` );
    res.send( `Mensagem publicada com sucesso. ID: ${ messageId }` );
  } catch ( error ) {
    console.error( 'Erro ao publicar mensagem:', error );
    res.status( 500 ).send( 'Erro ao publicar mensagem no Pub/Sub' );
  }
} );
