#!/bin/sh

WORKDIR=$HOME/.config/shell-pkg
TODOLIST=$WORKDIR/todo-list
ANSWER_FILE=`mktemp --suffix=-shell-pkg`

exit_handler() { trap - EXIT; rm -f "$ANSWER_FILE"; }
trap exit_handler EXIT HUP INT QUIT PIPE TERM

mkdir -p $WORKDIR
test -r $TODOLIST || touch $TODOLIST
TODOCOUNT=`wc -l < $TODOLIST`

Auto_screensize() {
	eval `dialog --print-maxsize --stdout | sed -E 's/.* (.*), (.*)/W=\1; H=\2; WW=$((W-10)); HH=$((H-10))/'`
}

Menu() {
	title="ShellPkg"

	Auto_screensize
	if dialog --title $title --ok-label "Choose" --cancel-label "Exit" \
		--menu "" $WW $HH 3 \
		Show_todo "Todo list" \
		Add_todo "Add todo" \
		Solve_todo "Solve todo" \
		2> "$ANSWER_FILE"
	then
		read answer < "$ANSWER_FILE"
		$answer
	fi
}

Add_todo() {
	title="Please write your TODO"
	Auto_screensize
	if dialog --inputbox "$title" $WW $HH 2> "$ANSWER_FILE"
	then
		read answer < "$ANSWER_FILE"
		((TODOCOUNT++))
		echo "$TODOCOUNT NEW $answer" >> $TODOLIST
	fi

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
	dialog --title "$title" --msgbox "$solved_todo$unsolved_todo" $WW $HH
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
	if dialog --title "$title" \
		   --checklist "" $WW $HH $count $unsolved_todo \
		   2> "$ANSWER_FILE"
	then
		read answer < "$ANSWER_FILE"
		for num in $answer; do
    		sed -i -E "s/($num) NEW/\\1 DONE/" "$TODOLIST"
		done
	fi
	
	Menu
}

Menu
