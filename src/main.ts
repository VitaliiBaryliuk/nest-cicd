import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import 'dotenv/config';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  const port = process.env.PORT || process.env.WEBSITES_PORT || 3000;
  await app.listen(port, () => {
    console.log(`Application is running on port ${port}`);
  });
}

bootstrap();
