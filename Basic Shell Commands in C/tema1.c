#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_INPUT_LINE_SIZE 300

struct Dir;
struct File;

typedef struct Dir{
	char *name;
	struct Dir* parent;
	struct File* head_children_files;
	struct Dir* head_children_dirs;
	struct Dir* next;
} Dir;

typedef struct File {
	char *name;
	struct Dir* parent;
	struct File* next;
} File;

//creates a new File* with the given name
File* create_new_file(Dir* parent, char* name)
{
	File *new_file = (File*)malloc(sizeof(File));
	new_file->name = malloc(strlen(name) + 1);
	strcpy(new_file->name, name);
	new_file->parent = parent;
	new_file->next = NULL;
	return new_file;
}

void touch (Dir* parent, char* name) {
	if(parent->head_children_files == NULL) { //if it's the first file
		parent->head_children_files = create_new_file(parent, name);
	}
	else {
		File *f, *ant = parent->head_children_files;
		int ok = 1;	//keeps track of whether the name exists
		//searching for the given name in the file list
		for(f = ant; (f != NULL) && ok; f = f->next) {
			if(f != ant) {
				ant = ant->next;
			}
			if(strcmp(f->name, name) == 0) {
				printf("File already exists\n");
				ok = 0;
			}
		}
		if(ok) {	//if the name doesn't already exist
			ant->next = create_new_file(parent, name);
		}
	}
}

//creates new Dir* with the given name
Dir* create_new_dir(Dir* parent, char* name)
{
	Dir *new_dir = (Dir *)malloc(sizeof(Dir));
	new_dir->name = malloc(strlen(name) + 1);
	strcpy(new_dir->name, name);
	new_dir->parent = parent;
	new_dir->head_children_files = NULL;
	new_dir->head_children_dirs = NULL;
	new_dir->next = NULL;
	return new_dir;
}

void mkdir (Dir* parent, char* name) {
	if(parent->head_children_dirs == NULL) {	//first directory
		parent->head_children_dirs = create_new_dir(parent, name);
	}
	else {
		Dir *d, *ant = parent->head_children_dirs;
		int ok = 1; //keeps track of whether the name exists
		//searching for the given name in the directory list
		for(d = ant; (d != NULL) && ok; d = d->next) {
			if(d != ant) {
				ant = ant->next;
			}
			if(strcmp(d->name, name) == 0) {
				printf("Directory already exists\n");
				ok = 0;
			}
		}
		if(ok) {	//if the name doesn't already exist
			ant->next = create_new_dir(parent, name);
		}
	}
}

void ls (Dir* parent) {
	//goes through each list (dirs + files) and prints the names
	for(Dir *d = parent->head_children_dirs; d != NULL; d = d->next) {
		puts(d->name);
	}
	for(File *f = parent->head_children_files; f != NULL; f = f->next) {
		puts(f->name);
	}
}

void free_file(File *f) {	//frees a file
	free(f->name);			//frees the name
	free(f);
	f = NULL;
}

void rm (Dir* parent, char* name) {
	int ok = 0; //keeps track of whether the element exists
	File *ant = parent->head_children_files, *f;
	//searching the list for the element
	for(f = parent->head_children_files; (f != NULL) && (!ok);) {
		if(strcmp(f->name, name) == 0) {
			ok = 1;		//the element is found
			//if the element is the head of the list
			if(f == parent->head_children_files) {
				parent->head_children_files = f->next;
			}
			else {
				ant->next = f->next;
			}
			File* f1 = f;
			f = f->next;
			free_file(f1);	//frees the file that is removed
		}
		if((!ok) && (f != NULL) && (ant != NULL) && (f != ant))
			ant = ant->next;
		if(!ok)
			f = f->next;
	}
	if(!ok)	//the element was not found
		printf("Could not find the file\n");
}

//deletes all files from a directory
void rm_all_files(Dir *d) {
	File *f = d->head_children_files;
	while(f != NULL) {
		d->head_children_files = f->next;
		File *f1 = f;
		f = d->head_children_files;
		free_file(f1);
	}
}

void free_dir(Dir *d) {		//frees a directory
	free(d->name);			//frees the name
	free(d);
	d = NULL;
}

void rmdir (Dir* parent, char* name) {
	int ok = 0; //keeps track of whether the element exists
	Dir *ant = parent->head_children_dirs, *d;
	//searching the list for the element
	for(d = parent->head_children_dirs; (d != NULL) && (!ok);) {
		if(strcmp(d->name, name) == 0) {
			ok = 1;		//the element is found
			//if the element is the head of the list
			if(d == parent->head_children_dirs) {
				parent->head_children_dirs = d->next;
			}
			else {
				ant->next = d->next;
			}
			//deleting all directories within the found directory
			Dir *dd = d->head_children_dirs;
			for(; dd != NULL;) {
				Dir *d1 = dd;
				dd = dd->next;
				rmdir(d1, d1->name);
				rm_all_files(d1);
				free_dir(d1);
			}
			Dir *d1 = d;
			d = d->next;
			rm_all_files(d1);
			free_dir(d1);
		}
		if((!ok) && (d != ant) && (ant != NULL) && (d != NULL))
			ant = ant->next;
		if(!ok)
			d = d->next;
	}
	if(!ok)	//the element was not found
		printf("Could not find the dir\n");
}

void cd(Dir** target, char *name) {
	if(strcmp(name, "..") == 0) {
		if((*target)->parent != NULL) {	//if there is a parent dir
			*target = (*target)->parent;
		}
	}
	else {
		Dir* d = (*target)->head_children_dirs;
		int ok = 0;
		//searching the list for the element
		for(; (d != NULL) && (!ok); d = d->next) {
			if(strcmp(d->name, name) == 0) {
				ok = 1;	//the element is found
				*target = d;
			}
		}
		if(!ok) {	//the element was not found
			printf("No directories found!\n");
		}
	}
}

char *pwd (Dir* target) {
	char *string = malloc(sizeof(char) * MAX_INPUT_LINE_SIZE);
	strcpy(string, target->name);	//the given name
	//going up until the root parent 'home' is reached
	for(Dir *d = target->parent; d != NULL; d = d->parent) {
		char *str = malloc(sizeof(char) * MAX_INPUT_LINE_SIZE);
		strcpy(str, d->name);	//the name of the parent
		strcat(str, "/");
		strcat(str, string); //puting the string in the right order
		strcpy(string, str);	
		free(str);
	}
	return string;
}

//removes all directories from a given parent directory
void rm_all_directories(Dir* parent) {
	if(parent != NULL) { //if there are directories to remove
		Dir *d = parent->head_children_dirs;
		for(; d != NULL;) { //for each directory
			Dir *d1 = d->head_children_dirs;
			for(; d1 != NULL; ) {
				Dir *d2 = d1;
				d1 = d1->next;
				rm_all_directories(d2);
				rm_all_files(d2);
				free_dir(d2);
			}
			Dir *d2 = d;
			d = d->next;
			rm_all_files(d2);
			free_dir(d2);
		}
		parent->head_children_dirs = NULL;
	}
}

void stop (Dir* target) {	//removes all directories and files
	rm_all_directories(target);
	rm_all_files(target);
	free_dir(target);
}

void tree (Dir* target, int level) {
	Dir *d = target->head_children_dirs;
	for(; d != NULL; d = d->next) { //for each directory
		for(int i = 0; i < level * 4; i++) {
			printf(" ");
		}
		printf("%s\n", d->name);
		tree(d, (level + 1));	//recursively finding all files
		for(File *f = target->head_children_files; f != NULL; f = f->next) {
			for(int i = 0; i < level * 4; i++) {
				printf(" ");
			}
			printf("%s\n", f->name);
		}
	}
}

void mv(Dir* parent, char *oldname, char *newname) {
	Dir *d = parent->head_children_dirs;
	Dir *old_d = NULL, *new_d = NULL, *ant_d = d;
	File *old_f = NULL, *new_f = NULL, *ant_f;
	int ok_old = 0, ok_new = 0;
	//searching in the dir list for the oldname
	for(; d != NULL; d = d->next) {
		if(strcmp(d->name, oldname) == 0) {
			ok_old = 1;	//it is found
			old_d = d;
		}
		if(ant_d != d) {
			ant_d = ant_d->next;
		}
	}
	if(!ok_old) {	//if the name isn't found
		File *f = parent->head_children_files;
		ant_f = f;
		//searching in the file list for the oldname
		for(; f != NULL; f = f->next) {
			if(strcmp(f->name, oldname) == 0) {
				ok_old = 1;	//it is found
				old_f = f;
			}
			if(ant_f != f) {
				ant_f = ant_f->next;
			}
		}
		if(!ok_old) {	//if the name isn't found again
			printf("File/Director not found\n");
			return;
		}
	}
	
	d = parent->head_children_dirs;
	//searching in the dir list for the newname
	for(; d != NULL; d = d->next) {
		if(strcmp(d->name, newname) == 0) {
			ok_new = 1;	//it is found
		}
	}
	if(!ok_new) {	//if it isn't found
		File *f = parent->head_children_files;
		//searching in the file list for the newname
		for(; f != NULL; f = f->next) {
			if(strcmp(f->name,newname) == 0) {
				ok_new = 1;	//it is found
			}
		}
	}
	if(ok_new) {	//if it is found
		printf("File/Director already exists\n");
		return;
	}
	
	if(old_d) {	//if a directory needs to be moved
		//if it is the head of the dir list
		if(parent->head_children_dirs == old_d) {
			parent->head_children_dirs = old_d->next;
		}
		else {
			ant_d->next = old_d->next;
		}
		new_d = create_new_dir(parent, newname);
		new_d->head_children_files = old_d->head_children_files;
		new_d->head_children_dirs = old_d->head_children_dirs;
		d = parent->head_children_dirs;
		//placing the new dir at the end of the dir list
		if(d != NULL) {
			for(; d->next != NULL; d = d->next);
			d->next = new_d;
		}
		else {	//if it is only one directory
			parent->head_children_dirs = new_d;
		}
		free_dir(old_d);
	}
	else if(old_f) { //if a file needs to be moved
		//if it is the head of the file list
		if(parent->head_children_files == old_f) {
			parent->head_children_files = old_f->next;
		}
		else {
			ant_f->next = old_f->next;
		}
		new_f = create_new_file(parent, newname);
		File *f = parent->head_children_files;
		//placing the new file at the end of the file list
		if(f != NULL) {
			for(; f->next != NULL; f = f->next);
			f->next = new_f;
		}
		else {	//if it is only one file
			parent->head_children_files = new_f;
		}
		free_file(old_f);
	}
}

//returns the name from the strtok function
char* get_name(char *source, char *del) {
	char *name = strtok(source, del);
	if(name[strlen(name) - 1] == '\n')
		name[strlen(name) - 1] = '\0';
	if(name[strlen(name) - 1] == ' ')
		name[strlen(name) - 1] = '\0';
	return name;
}

int main () {

	//initializing parent directory 'home'
	Dir *parent = create_new_dir(NULL, "home\0");
	Dir *always_parent = parent;	//a copy of the parent
	
	do
	{
		//string is reading each line from the stdin
		char *string = malloc(MAX_INPUT_LINE_SIZE * sizeof(char));
		fgets(string, MAX_INPUT_LINE_SIZE, stdin);
		
		char *command_name = get_name(string, " ");
		
		/* for each command received, it is compared to the 
		   expected commands and the required function is called */
		if(strcmp(command_name, "touch") == 0) {
			char *file_name = get_name(NULL, " ");
			touch(parent, file_name);
		}
		else if(strcmp(command_name, "mkdir") == 0) {
			char *dir_name = get_name(NULL, " ");
			mkdir(parent, dir_name);
		}
		else if(strcmp(command_name, "ls") == 0) {
			ls(parent);
		}
		else if(strcmp(command_name, "rm") == 0) {
			char *file_name = get_name(NULL, " ");
			rm(parent, file_name);
		}
		else if(strcmp(command_name, "rmdir") == 0) {
			char *dir_name = get_name(NULL, " ");
			rmdir(parent, dir_name);
		}
		else if(strcmp(command_name, "cd") == 0) {
			char *dir_name = get_name(NULL, " ");
			cd(&parent, dir_name);
		}
		else if(strcmp(command_name, "stop") == 0) {
			stop(always_parent);
			free(string);
			break;
		}
		else if(strcmp(command_name, "tree") == 0) {
			tree(parent, 0);
		}
		else if(strcmp(command_name, "pwd") == 0) {
			char *string = pwd(parent);
			printf("/%s\n", string);
			free(string);
		}
		else if(strcmp(command_name, "mv") == 0) {
			char *oldname = get_name(NULL, " ");
			char *newname = get_name(NULL, " ");
			mv(parent, oldname, newname);
		}

		free(string);
	} while(1);
	
	return 0;
}
