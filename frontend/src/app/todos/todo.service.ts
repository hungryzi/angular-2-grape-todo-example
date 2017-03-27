import { Injectable, Inject } from '@angular/core';
import { Http } from '@angular/http';
import { Todo } from './todo';

import 'rxjs/add/operator/toPromise';

@Injectable()
export class TodoService {
  constructor(
    private http: Http,

    @Inject('apiEndpoint')
    private apiEndpoint: string
  ) { }

  getTodos(): Promise<Todo[]> {
    return this.http.get(`${this.apiEndpoint}/todos`)
      .toPromise()
      .then((response) => {
        return response.json()._embedded.todos as Todo[];
      })
      .catch(this.handleError);
  }

  private handleError(error) {
    console.error('An error occurred', error);
    return Promise.reject(error.message || error);
  }
}
