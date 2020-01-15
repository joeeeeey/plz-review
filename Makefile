test_github_get_pr_info:
	/usr/bin/ruby main.rb "github_pr,sdsd"

test_verify_pr_url:
	/usr/bin/ruby main.rb "verify_pr_url,https://github.com/Overseas-Student-Living/properties-service/pull/1"

test_get_pr_info:
	/usr/bin/ruby main.rb "get_pr_info,https://github.com/Overseas-Student-Living/properties-service/pull/1/commits"