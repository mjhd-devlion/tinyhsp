#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "token.h"
#include "lexer.h"
#include "parser.h"

static void my_get_token(Token* token);
static void unget_token(Token* token);
static double parser_primary_expression();
static double parser_term();

static Token st_token;
static int st_token_exists;

// テスト用コード
/*
int
main(int argc, char** argv)
{
	char line[LINE_BUF_SIZE];
	double value;
	while (fgets(line, LINE_BUF_SIZE, stdin) != NULL) {
		set_line(line);
		value = parse_line();
		printf(">>%f\n", value);
	}
	return 0;
}

double
parse_line(void)
{
	double value;
	st_token_exists = 0;
	value = parse_expression();
	return value;
}
*/
//

void set_st_token_exists(int value) {
	st_token_exists = value;
}

double
parser_expression() {
	double v1;
	double v2;
	Token token;
	
	v1 = parser_term();
	for (;;) {
		my_get_token(&token);
		if (token.group != ADD_TOKEN
			&& token.group != SUB_TOKEN) {
			unget_token(&token);
			break;
		}
		v2 = parser_term();
		if (token.group == ADD_TOKEN) {
			v1 = v1 + v2;
		} else if (token.group == SUB_TOKEN) {
			v1 = v1 - v2;
		} else {
			unget_token(&token);
		}
	}
	
	return v1;
}

//

static void
my_get_token(Token* token) {
	if (st_token_exists) {
		*token = st_token;
		st_token_exists = 0;
	} else {
		get_token(token);
	}
}

static void
unget_token(Token* token) {
	st_token = *token;
	st_token_exists = 1;
}

static double
parser_primary_expression() {
	Token token;
	double value = 0.0;
	bool minus_flag = false;
	
	// 負の数に対応
	my_get_token(&token);
	if (token.group == SUB_TOKEN) {
		minus_flag = true;
	} else {
		unget_token(&token);
	}
	
	my_get_token(&token);
	if (token.group == NUM_TOKEN) {
		value = token.value;
	} else if (token.group == LP_TOKEN) { // 括弧に対応
		value = parser_expression();
		my_get_token(&token);
		if (token.group != RP_TOKEN) {
			fprintf(stderr, "')'が見つかりません\n");
			exit(1);
		}
	} else {
		unget_token(&token);
	}
	if (minus_flag) {
		value = -value;
	}
	return value;
}

static double
parser_term() {
	double v1;
	double v2;
	Token token;
	
	v1 = parser_primary_expression();
	for (;;) {
		my_get_token(&token);
		if (token.group != MUL_TOKEN
			&& token.group != DIV_TOKEN) {
			unget_token(&token);
			break;
		}
		v2 = parser_primary_expression();
		if (token.group == MUL_TOKEN) {
			v1 = v1 * v2;
		} else if (token.group == DIV_TOKEN) {
			v1 = v1 / v2;
		}
	}
	
	return v1;
}