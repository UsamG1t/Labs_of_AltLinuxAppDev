#!/bin/sh

WORKDIR=$HOME/.config/shell-pkg
TODOLIST=$WORKDIR/todo-list
ANSWER_FILE=`mktemp --suffix=-shell-pkg`

exit_handler() { trap - EXIT; rm -f "$ANSWER_FILE"; }
trap exit_handler EXIT HUP INT QUIT PIPE TERM

Start_check() {
	if [ ! -d "$WORKDIR" ]; then
		mkdir "$WORKDIR"
	fi
	touch $TODOLIST
	TODOCOUNT=`cat $TODOLIST | wc -l`
}

Auto_screensize() {
	eval `dialog --print-maxsize --stdout | sed -E 's/.* (.*), (.*)/W=\1; H=\2/'`
}

Menu() {
	title="ShellPkg"
	point0="0 Todo-list"
	point1="1 Add_todo"
	point2="2 Solve_todo"

	Auto_screensize
	dialog --title $title --ok-label "Choose" --cancel-label "Exit" \
		   --menu "" $(($W-10)) $(($H-10)) 3 $point0 $point1 $point2 2> "$ANSWER_FILE"

	if [ $? = 0 ]; then
		read answer < "$ANSWER_FILE"
		echo $answer
		case $answer in
			0)
				Show_todo
				;;
			1)
				Add_todo
				;;
			2)
				Solve_todo
				;;
		esac
	fi
}

Add_todo() {
	title="Please write your TODO"
	Auto_screensize
	dialog --inputbox "$title" $(($W-10)) $(($H-10)) 2> "$ANSWER_FILE"

	if [ $? = 0 ]; then
		read answer < "$ANSWER_FILE"
		((TODOCOUNT++))
		(echo -n "$TODOCOUNT NEW " && echo $answer) >> $TODOLIST
	fi

	# cat $TODOLIST
	Menu	

}

Show_todo() {
	title="List of all your TODO"
	solved_todo="Solved todo:\n"
	unsolved_todo="Unsolved todo:\n"
	
	while read number status todo; do
		if [ $status = "NEW" ]; then
			unsolved_todo="$unsolved_todo - $todo\n"
		else
			solved_todo="$solved_todo - $todo\n"
		fi
	done < "$TODOLIST"

	Auto_screensize
	dialog --title "$title" \
			--msgbox "$(echo $solved_todo && echo $unsolved_todo)" $(($W-10)) $(($H-10))
	Menu
}


Solve_todo() {
	title="Point solved todo"
	unsolved_todo=""
	count=0
	while read number status todo; do
		if [ $status = "NEW" ]; then
			unsolved_todo="$unsolved_todo $number $todo off"
			((count++))
		fi
	done < "$TODOLIST"

	Auto_screensize
	dialog --title "$title" \
		   --checklist "" $(($W-10)) $(($H-10)) $count $(echo $unsolved_todo) \
		   2> "$ANSWER_FILE"

	if [ $? = 0 ]; then
		read answer < "$ANSWER_FILE"
		for num in $answer; do
    		sed -i -E "s/($num) NEW/\\1 DONE/" "$TODOLIST"
		done
	fi
	
	Menu
}

Start_check
Menu
