local util = {
	'log',
	'ut_string',
	'ut_table',
	'async',
}
for i = 1, #util do
	require('util.' .. util[i])
end

require 'restrict_global'