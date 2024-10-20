#!/bin/bash

YEAR=$(date +%Y)
WEEK_START=$(date -v -Mon "+%m-%d-%Y")
TODAY=$(date +%m-%d-%Y)

# Directory paths
BASE_DIR="$HOME/todo/$YEAR"
TODO_DIR="$BASE_DIR/todo"
HABIT_DIR="$BASE_DIR/habit"
STATUS_DIR="$BASE_DIR/status"

mkdir -p "$TODO_DIR" "$HABIT_DIR" "$STATUS_DIR"

# Generate weekly habit tracker template
generate_habit_template() {
  HABIT_FILE="$HABIT_DIR/$WEEK_START.md"
  if [ ! -f "$HABIT_FILE" ]; then
    title="Habit Tracker: Week of $WEEK_START"
    title_line=$(printf '%*s' "${#title}" '' | tr ' ' '-')
    echo "$title_line" > "$HABIT_FILE"
    echo "$title" >> "$HABIT_FILE"
    echo "$title_line" >> "$HABIT_FILE"
    echo "" >> "$HABIT_FILE"
    echo "" >> "$HABIT_FILE"
    
    declare -a habits=("A" "B" "C" "" "D" "E" "F")
    
    # Generate day headers with formatted dates
    echo -n "| Habit          " >> "$HABIT_FILE"
    for day_offset in {0..6}; do
      day_header=$(date -v +${day_offset}d -jf "%m-%d-%Y" "$WEEK_START" "+%a %m/%d")
      printf "| %-13s " "$day_header" >> "$HABIT_FILE"
    done
    echo "|" >> "$HABIT_FILE"
    
    echo "| -------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |" >> "$HABIT_FILE"
    echo "|                |               |               |               |               |               |               |               |" >> "$HABIT_FILE"
    
    for habit in "${habits[@]}"; do
      if [ -z "$habit" ]; then
        echo "|                |               |               |               |               |               |               |               |" >> "$HABIT_FILE"
      else
        printf "| %-14s " "$habit" >> "$HABIT_FILE"
        for i in {1..7}; do
          echo -n "|      -        " >> "$HABIT_FILE"
        done
        echo "|" >> "$HABIT_FILE"
      fi
    done

    echo "|                |               |               |               |               |               |               |               |" >> "$HABIT_FILE"
    
  fi
  vim "$HABIT_FILE"
}

# Generate weekly todo template
generate_todo_template() {
  TODO_FILE="$TODO_DIR/$WEEK_START.md"
  if [ ! -f "$TODO_FILE" ]; then
    title="Todo - Week of $WEEK_START"
    title_line=$(printf '%*s' "${#title}" '' | tr ' ' '-')
    echo "$title_line" > "$TODO_FILE"
    echo "$title" >> "$TODO_FILE"
    echo "$title_line" >> "$TODO_FILE"
    echo "" >> "$TODO_FILE"
    echo "" >> "$TODO_FILE"
    
    for day_offset in {0..6}; do
      day_name=$(date -v +${day_offset}d -jf "%m-%d-%Y" "$WEEK_START" "+%A %B %d, %Y")
      echo "$day_name" >> "$TODO_FILE"
      # Generate a line of dashes equal in length to $day_name
      echo "$(printf '%*s' "${#day_name}" '' | tr ' ' '-')" >> "$TODO_FILE"
      echo "" >> "$TODO_FILE"
      echo "- " >> "$TODO_FILE"
      echo "" >> "$TODO_FILE"
      echo "" >> "$TODO_FILE"
    done
  fi
  vim "$TODO_FILE"
}

# Generate daily status update template
generate_status_template() {
  STATUS_FILE="$STATUS_DIR/$TODAY.md"
  if [ ! -f "$STATUS_FILE" ]; then
    title="Status: $TODAY"
    title_line=$(printf '%*s' "${#title}" '' | tr ' ' '-')
    echo "$title_line" > "$STATUS_FILE"
    echo "$title" >> "$STATUS_FILE"
    echo "$title_line" >> "$STATUS_FILE"
    echo "" >> "$STATUS_FILE"
    echo "" >> "$STATUS_FILE"
    echo "- 9:00 AM :" >> "$STATUS_FILE"
  fi
  vim "$STATUS_FILE"
}

# Handle command-line arguments
case "$1" in
  habit)
    generate_habit_template
    ;;
  todo)
    generate_todo_template
    ;;
  status)
    generate_status_template
    ;;
  *)
    echo "Usage: $0 {habit|todo|status}"
    ;;
esac

