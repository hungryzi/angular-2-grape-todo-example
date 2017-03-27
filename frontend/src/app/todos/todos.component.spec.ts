import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { TodoService } from './todo.service';
import { TodosComponent } from './todos.component';
import { Todo } from './todo';

describe('TodosComponent', () => {
  let component: TodosComponent;
  let fixture: ComponentFixture<TodosComponent>;
  let todos: Todo[];

  beforeEach(async(() => {
    todos = [
      new Todo('1', 'Get some tea'),
      new Todo('2', 'Wash the dishes'),
    ];

    const dummyTodoService = {
      getTodos: jasmine.createSpy('getTodos').and.returnValue(Promise.resolve(todos))
    };

    TestBed.configureTestingModule({
      declarations: [ TodosComponent ]
    })
    .overrideComponent(TodosComponent, {
      set: {
        providers: [
          { provide: TodoService, useValue: dummyTodoService }
        ]
      }
    });
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TodosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should render todos', () => {
    fixture.whenStable().then(() => {
      fixture.detectChanges();

      const compiled = fixture.debugElement.nativeElement;
      expect(compiled.textContent).toContain('Get some tea');
      expect(compiled.textContent).toContain('Wash the dishes');
    });
  });
});
