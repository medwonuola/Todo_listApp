import 'package:flutter/material.dart';
import 'package:todo_list/todo_model.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List',
      theme: ThemeData(
        primaryColor: Colors.blue.shade900,
      ),
      home: TodoHome(title: 'Todo List'),
    );
  }
}

class TodoHome extends StatefulWidget {
  TodoHome({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TodoHomeState createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  TodoModel _currentTodo = TodoModel();
  List<TodoModel> _list = [];

  final _formKey = GlobalKey<FormState>();

  void _submit() {
    // the statement below is to hide the keyboard.
    // so when a user submits the todo, it hides the keyboard
    FocusScope.of(context).unfocus();
    // what this work for i d
    // ok?
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _list.add(TodoModel(todo: _currentTodo.todo));
      form.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        // NO PROBLEM BRO CARRY
      },
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _inputBody(),
              _submitTodoButton(),
              _todoListBody(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _todoListBody(BuildContext context) {
    return Expanded(
      child: Container(
        child: ListView.builder(
            itemCount: _list.length,
            // cnt is bad naming. use "ctx" or "context"
            //
            itemBuilder: (ctx, i) {
              return Padding(
                padding: EdgeInsets.all(8),
                child: Dismissible(
                  key: Key(_list[i].todo),
                  onDismissed: (d) {
                    _list.removeAt(i);
                    // yes
                  },
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                          child: IconButton(
                              onPressed: () {}, icon: Icon(Icons.done))),
                      title: Text(
                        _list[i].todo,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget _inputBody() => Form(
        key: _formKey,
        child: Container(
            child: Column(children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Todo',
            ),
            onSaved: (s) => setState(() => _currentTodo.todo = s),
            validator: (vl) => vl.isEmpty ? 'input todo' : null,
          ),
          SizedBox(
            height: 10,
          ),
        ])),
      );

  Widget _submitTodoButton() => Container(
        width: double.infinity,
        color: Theme.of(context).primaryColor,
        child: TextButton(
          onPressed: _submit,
          child: Text(
            'Add Todo',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
}
