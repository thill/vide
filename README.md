# vide
Open all of your development projects with one command from anywhere on your system.
```
$ vide open my_awesome_project
```

## Installation
```
$ sudo make install
$ sudo make install-templates
```


## Usage
```
vide help
vide list
vide details <NAME>
vide open <NAME>
vide delete <NAME>
vide create command <NAME> COMMAND='vi'
vide create vscode <NAME> WORKSPACE='/src/myproject' COMMAND='code ${WORKSPACE}'
vide create vscode_ssh <NAME> HOST='127.0.0.1' WORKSPACE='/src/myproject' COMMAND='code --remote ssh-remote+${HOST} ${WORKSPACE}'
```
Note that all `vide create` lines contain default values for each configurable property


## Creating a Simple Project
Projects are create in the form of `vide create project <PROJECT_TEMPLATE> <PROJECT_NAME> <PROPERTIES>...`:
Let's assume our example project simply uses `vim` to edit `~/.ssh/config`.
Let's create a project from the `command` templates:
```
$ vide create command sshconfig 'COMMAND=vim ${HOME}/.ssh/config'
```
For variable resolution to occur by vive when opening a project, be sure to use single quote your properties!

Next, let's open our project:
```
$ vide open sshconfig
```

That's it! Now you can now edit your ssh config from anywhere on your system by typing `vive open sshconfig`.


## Listing Projects
This will display all vide projects along with their respective startup commands:
```
$ vide list
sshconfig  ->  vim /home/eric/.ssh/config
```
Notice that all variables have been resolved so you can get a clear picture of the full command run for each project.


## Creating a VS Code Project
Let's add a VS Code project for a specific workspace and list our projects.
```
$ vide create vscode myproj 'WORKSPACE=${HOME}/git/myproj'
Creating vide project 'myproj' in '/home/eric/.vide/projects/myproj'

$ vide list
myproj     ->  code /home/eric/git/myproj
sshconfig  ->  vim /home/eric/.ssh/config
```
Notice that by specifying `WORKSPACE`, the `vscode` template knows to open the workspace with VS Code's `code` command.
Running `vide open myproj` will open our project in vscode.


## Creating an SSH VS Code Project
VS Code has built-in support for remote development over SSH.
A vide template exists to specify an ssh `HOST` and remote `WORKSPACE` directory.
```
$ vide create vscode_ssh remoteproj HOST=myserver WORKSPACE=/home/eric/workspaces/proj
Creating vide project 'remoteproj' in '/home/eric/.vide/projects/remoteproj'
$ vide list
myproj      ->  code /home/eric/.ssh/myproj
remoteproj  ->  code --remote ssh-remote+myserver /home/eric/workspaces/proj
sshconfig   ->  vim /home/eric/.ssh/config
```
Running `vide open remoteproj` will open VS Code, and directly connect to the remote workspace. 
Tip: Manage apsects of your `myserver` connection in `~/.ssh/config`


## Adding More Project Templates
All vide projects are templated.
New templates can be added to `~/.vide/templates/`, `/usr/local/etc/vide/templates`, or `/etc/vide/templates`.
At a minimum, a template is a directory that consists of a `defaults` file.
The `defaults` file is a list of key/value pairs that are used by the project and filled with appropriate default values.
The `defaults` file should also consist of a `COMMAND`, which is used to construct the command from templated variables.

Consider the following example for `my_awesome_ide`, which accepts a `-d` flag to open a specific directory.
First, let's add the following file to `~/.vide/templates/my_awesome_ide/defaults:
```
DIRECTORY=/path/to/my/project
COMMAND=my_awesome_ide -d "${DIRECTORY}"
```

Next, let's take a look at `vide help`:
```
Usage:
       vide help
       vide list
       vide details <NAME>
       vide open <NAME>
       vide delete <NAME>
       vide create command <NAME> COMMAND='vi'
       vide create my_awesome_ide <NAME> DIRECTORY='/path/to/my/project' COMMAND='my_awesome_ide -d "${DIRECTORY}"'
       vide create vscode <NAME> WORKSPACE='/src/myproject' COMMAND='code ${WORKSPACE}'
       vide create vscode_ssh <NAME> HOST='127.0.0.1' WORKSPACE='/src/myproject' COMMAND='code --remote ssh-remote+${HOST} ${WORKSPACE}'
```
Notice that `my_awesome_ide` has been added to the help list automatically.

Now we can try to create a `my_awesome_ide` project:
```
$ vide create my_awesome_ide my_awesome_project 'DIRECTORY=${HOME}/git/awesome_project'
Creating vide project 'my_awesome_project' in '/home/eric/.vide/projects/my_awesome_project'
```

Listing our projects shows what will be run for `vide open my_awesome_project`
```
$ vide list
my_awesome_project  ->  my_awesome_ide -d /home/eric/git/awesome_project
myproj              ->  code /home/eric/git/myproj
remoteproj          ->  code --remote ssh-remote+myserver /home/eric/workspaces/proj
sshconfig           ->  vim /home/eric/.ssh/config
```

The working directory for a vide command will be the directory of the vide project, which can be useful when complex scripts are needed instead of simple commands.


## Debugging
You can use `vide details <NAME>` to get a sense of how commands are resolved.
Here's the example of our `my_awesome_project` created earlier in this document:
```
$ vide details my_awesome_project
name: my_awesome_project
directory: /home/eric/.vide/projects/my_awesome_project
--- defaults ---
DIRECTORY='/path/to/my/project'
COMMAND='my_awesome_ide -d "${DIRECTORY}"'
--- properties ---
DIRECTORY='${HOME}/git/awesome_project'
```
First, vide loads defaults. Then it loads properties. Then it evaluates the `COMMAND` and executes it.
