# vide
Open all of your development projects with one command from anywhere on your system.


## Installation
Install `vide` with the base `command` template:
```
$ sudo make install
```

Install additions templates:
```
$ sudo make install-templates
```


## Usage
Usage specified by `vide help`:
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
Note that all `vide create` lines contain the default values 


## Simple Project Quickstart
Let's assume our example project simply uses vim to edit ~/.ssh/config.
First, we'll create the most simple project vide supports: a single command.
```
$ vide create command sshconfig 'COMMAND=vim ${HOME}/.ssh/config'
Creating vide project 'sshconfig' in '/home/eric/.vide/projects/sshconfig'
```
If you want variable resolution to occur when opening a project, be sure to use single quotes around your configuration parameters.

Next, let's try to open our project:
```
$ vide open sshconfig
```
~/.ssh/config is opened in vim

Let's look around a little more and list all vide projects.
This will display all vide projects along with their respective startup commands.
```
$ vide list
sshconfig  ->  vim /home/eric/.ssh/config
```
Notice that all variables have been resolved so you can get a clear picture of the full command run for each project.


## Creating a VS Code Project
Let's add a VS Code project for a specific workspace and list our projects.
```
$ vide create vscode vide 'WORKSPACE=${HOME}/git/vide'
Creating vide project 'vide' in '/home/eric/.vide/projects/vide'

$ vide list
sshconfig  ->  vim /home/eric/.ssh/config
vide       ->  code /home/eric/git/vide
```
Notice that by specifying `WORKSPACE`, the `vscode` template knows to open the workspace with VS Code's `code` command.
Running `vide open vide` will open our project in vscode.


## Creating an SSH VS Code Project
VS Code has built-in support for remote development over SSH.
A vide template exists to specify an ssh `HOST` and remote `WORKSPACE` directory.
```
$ vide create vscode_ssh remoteproj HOST=myserver WORKSPACE=/home/eric/workspaces/proj
Creating vide project 'remoteproj' in '/home/eric/.vide/projects/remoteproj'
$ vide list
remoteproj  ->  code --remote ssh-remote+myserver /home/eric/workspaces/proj
sshconfig   ->  vim /home/eric/.ssh/config
vide        ->  code /home/eric/git/vide
```
Running `vide open remoteproj` will open VS Code, and directly connect to the remote workspace. 
Tip: Manage apsects of your `myserver` connection in `~/.ssh/config`


## Adding Project Templates
All vide projects are templated.
New templates can be added to `~/.vide/templates/`, `/usr/local/etc/vide/templates`, or `/etc/vide/templates`.
At a minimum, a template is a directory that consists of a `defaults` file.
The `defaults` file is a list of key/value pairs that are used by the project, filled with appropriate defaults.
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

And listing our projects shows what will be run for `vide open my_awesome_project`
$ vide list
my_awesome_project  ->  my_awesome_ide -d /home/eric/git/awesome_project
remoteproj          ->  code --remote ssh-remote+myserver /home/eric/workspaces/proj
sshconfig           ->  vim /home/eric/.ssh/config
vide                ->  code /home/eric/git/vide

The working directory for a vide command will be the directory of the vide project.
In this case, that would be `/home/eric/.vide/projects/my_awesome_project`.
This can be useful for complex scripting requirements.

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
