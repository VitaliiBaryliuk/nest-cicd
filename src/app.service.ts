import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello(): string {
    return 'Hello World!';
  }

  getHola(): string {
    return 'Hola World!';
  }

  getHealth(): any {
    return { status: 'OK' };
  }
}
