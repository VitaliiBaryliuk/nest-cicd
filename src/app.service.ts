import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello(): string {
    return 'Hello World 1!';
  }

  getHola(): string {
    return 'Hola World!';
  }
}
