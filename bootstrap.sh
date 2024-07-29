#!/bin/bash

set -e

username="worker"
dbname="master"
port=5432
host="localhost"

# parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    --username)
      username="$2"
      shift
      shift
      ;;
    --dbname)
      dbname="$2"
      shift
      shift
      ;;
    --port)
      port="$2"
      shift
      shift
      ;;
    --host)
      host="$2"
      shift
      shift
      ;;
    *)
      echo "Usage: $0 [--username USERNAME] [--dbname DBNAME] [--port PORT] [--host HOST]"
      exit 1
      ;;
  esac
done

psql --username "${username}" \
     --dbname "${dbname}" \
     --port "${port}" \
     --host "${host}" \
     --quiet \
     --command "BEGIN;" \
     --command "SET client_min_messages TO 'ERROR';" \
     --file "$PROJECT_DIR/schemas.sql" \
\
     --file "$PROJECT_DIR/common/domains/email_t.sql" \
     --file "$PROJECT_DIR/common/domains/pos_t.sql" \
     --file "$PROJECT_DIR/common/domains/tag_color_t.sql" \
     --file "$PROJECT_DIR/common/functions/quote_meta.sql" \
     --file "$PROJECT_DIR/common/procedures/gen_search_pattern.sql" \
     --file "$PROJECT_DIR/common/procedures/validate_rpp_and_page.sql" \
     --file "$PROJECT_DIR/common/procedures/validate_sort_expr.sql" \
\
     --file "$PROJECT_DIR/users/tables/role_table.sql" \
     --file "$PROJECT_DIR/users/tables/user_table.sql" \
     --file "$PROJECT_DIR/users/tables/blocked_user_table.sql" \
     --file "$PROJECT_DIR/users/tables/settings/predefined_user_setting_table.sql" \
     --file "$PROJECT_DIR/users/tables/settings/user_setting_table.sql" \
     --file "$PROJECT_DIR/users/procedures/assert_user_exists.sql" \
     --file "$PROJECT_DIR/users/procedures/assert_predefined_user_setting_exists.sql" \
     --file "$PROJECT_DIR/users/functions/make_user.sql" \
     --file "$PROJECT_DIR/users/functions/fetch_users.sql" \
     --file "$PROJECT_DIR/users/functions/fetch_user_by.sql" \
     --file "$PROJECT_DIR/users/functions/fetch_user_by_email.sql" \
     --file "$PROJECT_DIR/users/functions/fetch_user_by_id.sql" \
     --file "$PROJECT_DIR/users/functions/fetch_blocked_users.sql" \
     --file "$PROJECT_DIR/users/functions/promote_user_to_admin.sql" \
     --file "$PROJECT_DIR/users/functions/unblock_user.sql" \
     --file "$PROJECT_DIR/users/functions/update_user.sql" \
     --file "$PROJECT_DIR/users/functions/delete_user_hardly.sql" \
     --file "$PROJECT_DIR/users/functions/degrade_admin_to_user.sql" \
     --file "$PROJECT_DIR/users/functions/block_user.sql" \
     --file "$PROJECT_DIR/users/functions/settings/update_user_setting.sql" \
     --file "$PROJECT_DIR/users/functions/settings/fetch_user_settings.sql" \
     --file "$PROJECT_DIR/users/functions/settings/fetch_one_user_setting.sql" \
     --file "$PROJECT_DIR/users/triggers/check_setting_is_not_repeated.sql" \
     --file "$PROJECT_DIR/users/seeds/000_role_seed.sql" \
     --file "$PROJECT_DIR/users/seeds/001_user_seed.sql" \
     --file "$PROJECT_DIR/users/seeds/002_predfined_user_setting_seed.sql" \
     --file "$PROJECT_DIR/users/seeds/003_user_setting_seed.sql" \
\
     --file "$PROJECT_DIR/groups/tables/group_table.sql" \
     --file "$PROJECT_DIR/groups/tables/group_table.sql" \
     --file "$PROJECT_DIR/groups/procedures/assert_group_exists.sql" \
     --file "$PROJECT_DIR/groups/functions/delete_group.sql" \
     --file "$PROJECT_DIR/groups/functions/fetch_group_by_id.sql" \
     --file "$PROJECT_DIR/groups/functions/fetch_groups.sql" \
     --file "$PROJECT_DIR/groups/functions/make_group.sql" \
     --file "$PROJECT_DIR/groups/functions/update_group.sql" \
\
     --file "$PROJECT_DIR/lists/enums/special_list_type_enum.sql" \
     --file "$PROJECT_DIR/lists/tables/list_table.sql" \
     --file "$PROJECT_DIR/lists/tables/user_special_list_table.sql" \
     --file "$PROJECT_DIR/lists/procedures/assert_list_exists.sql" \
     --file "$PROJECT_DIR/lists/procedures/assert_list_exists_somewhere.sql" \
     --file "$PROJECT_DIR/lists/tables/list_table.sql" \
     --file "$PROJECT_DIR/lists/functions/convert_to_scattered_list.sql" \
     --file "$PROJECT_DIR/lists/functions/delete_list.sql" \
     --file "$PROJECT_DIR/lists/functions/duplicate_list.sql" \
     --file "$PROJECT_DIR/lists/functions/fetch_grouped_lists.sql" \
     --file "$PROJECT_DIR/lists/functions/fetch_list_by_id.sql" \
     --file "$PROJECT_DIR/lists/functions/fetch_lists.sql" \
     --file "$PROJECT_DIR/lists/functions/fetch_scattered_lists.sql" \
     --file "$PROJECT_DIR/lists/functions/get_deferred_list_id.sql" \
     --file "$PROJECT_DIR/lists/functions/get_today_list_id.sql" \
     --file "$PROJECT_DIR/lists/functions/get_tomorrow_list_id.sql" \
     --file "$PROJECT_DIR/lists/functions/make_deferred_list.sql" \
     --file "$PROJECT_DIR/lists/functions/make_list.sql" \
     --file "$PROJECT_DIR/lists/functions/make_today_list.sql" \
     --file "$PROJECT_DIR/lists/functions/make_tomorrow_list.sql" \
     --file "$PROJECT_DIR/lists/functions/move_list.sql" \
     --file "$PROJECT_DIR/lists/functions/update_list.sql" \
     --file "$PROJECT_DIR/lists/procedures/assert_is_not_special_list.sql" \
\
     --file "$PROJECT_DIR/tasks/enums/task_priority_enum.sql" \
     --file "$PROJECT_DIR/tasks/enums/task_status_enum.sql" \
     --file "$PROJECT_DIR/tasks/composites/task_creation_t.sql" \
     --file "$PROJECT_DIR/tasks/composites/task_update_t.sql" \
     --file "$PROJECT_DIR/tasks/tables/task_table.sql" \
     --file "$PROJECT_DIR/tasks/tables/trashed_task_table.sql" \
     --file "$PROJECT_DIR/tasks/tables/step_table.sql" \
     --file "$PROJECT_DIR/tasks/procedures/assert_task_exists.sql" \
     --file "$PROJECT_DIR/tasks/procedures/assert_task_exists_somewhere.sql" \
     --file "$PROJECT_DIR/tasks/functions/compute_next_task_pos.sql" \
     --file "$PROJECT_DIR/tasks/functions/defer_tasks_in_today_list.sql" \
     --file "$PROJECT_DIR/tasks/functions/delete_task.sql" \
     --file "$PROJECT_DIR/tasks/functions/duplicate_task.sql" \
     --file "$PROJECT_DIR/tasks/functions/fetch_task_by_id.sql" \
     --file "$PROJECT_DIR/tasks/functions/fetch_tasks_from_deferred_list.sql" \
     --file "$PROJECT_DIR/tasks/functions/fetch_tasks_from_today_list.sql" \
     --file "$PROJECT_DIR/tasks/functions/fetch_tasks_from_tomorrow_list.sql" \
     --file "$PROJECT_DIR/tasks/functions/fetch_tasks.sql" \
     --file "$PROJECT_DIR/tasks/functions/make_task.sql" \
     --file "$PROJECT_DIR/tasks/functions/move_task_from_list.sql" \
     --file "$PROJECT_DIR/tasks/functions/move_tasks_from_tomorrow_to_today_list.sql" \
     --file "$PROJECT_DIR/tasks/functions/move_task_to_deferred_list.sql" \
     --file "$PROJECT_DIR/tasks/functions/move_task_to_today_list.sql" \
     --file "$PROJECT_DIR/tasks/functions/move_task_to_tomorrow_list.sql" \
     --file "$PROJECT_DIR/tasks/functions/pin_task.sql" \
     --file "$PROJECT_DIR/tasks/functions/reorder_task_in_list.sql" \
     --file "$PROJECT_DIR/tasks/functions/restore_task_from_trash.sql" \
     --file "$PROJECT_DIR/tasks/functions/set_task_as_completed.sql" \
     --file "$PROJECT_DIR/tasks/functions/set_task_as_uncompleted.sql" \
     --file "$PROJECT_DIR/tasks/functions/set_task_due_date.sql" \
     --file "$PROJECT_DIR/tasks/functions/set_task_priority.sql" \
     --file "$PROJECT_DIR/tasks/functions/set_task_reminder_date.sql" \
     --file "$PROJECT_DIR/tasks/functions/trash_task.sql" \
     --file "$PROJECT_DIR/tasks/functions/unpin_task.sql" \
     --file "$PROJECT_DIR/tasks/functions/update_task.sql" \
\
     --command 'ALTER ROLE "worker"
                       SET search_path = "users",
                                         "groups",
                                         "lists",
                                         "tasks",
                                         "common",
                                         "addons";' \
     --command "SET client_min_messages TO 'NOTICE';" \
     --command "COMMIT;"
