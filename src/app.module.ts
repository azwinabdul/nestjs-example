import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MongooseModule } from '@nestjs/mongoose';
import { DogsModule } from './dogs/dog.module';

@Module({
  imports: [
    MongooseModule.forRoot('mongodb://172.17.0.1:27017/nest'),
    DogsModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
