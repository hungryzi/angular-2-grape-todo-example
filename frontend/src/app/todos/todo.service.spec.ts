import {
    BaseRequestOptions,
    Http,
    Response,
    ResponseOptions,
    XHRBackend
} from '@angular/http';

import {
  TestBed,
  inject,
  async
} from '@angular/core/testing';

import {Subject} from 'rxjs/Subject';

import {
  MockBackend,
  MockConnection
} from '@angular/http/testing'

import { TodoService } from './todo.service';

function mockResponse(options: any, backend: MockBackend) {
  backend.connections.subscribe((conn: MockConnection) => {
    const ro = new ResponseOptions(options);
    const r = new Response(ro);
    conn.mockRespond(r);
  });
}

describe('TodoService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        MockBackend,
        BaseRequestOptions,
        TodoService,
        { provide: 'apiEndpoint', useValue: '/test-api' },
        {
          deps: [MockBackend, BaseRequestOptions],
          provide: Http,
          useFactory: (backend: MockBackend, defaultOptions: BaseRequestOptions) => {
            return new Http(backend, defaultOptions);
          }
        }
      ]
    });
  });

  describe('fetching todos', () => {
    it('uses the api', async(inject([TodoService], (service: TodoService) => {
      const http = TestBed.get(Http) as Http;
      spyOn(http, 'get').and.returnValue(new Subject());

      service.getTodos();
      expect(http.get).toHaveBeenCalledWith('/test-api/todos');
    })));

    it('parses the response', async(inject([TodoService], (service: TodoService) => {
      const backend = TestBed.get(MockBackend) as MockBackend;
      const json = { '_embedded': {
        todos: [{
        id: '1',
        description: 'Buy some milk',
      }, {
        id: '2',
        description: 'Do laundry',
      }]}};

      mockResponse({
        body: json,
      }, backend);

      service.getTodos().then(todos => {
        expect(todos).toEqual(json['_embedded']['todos']);
      });
    })));
  });
});
