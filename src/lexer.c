#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdint.h>
#include <stdbool.h>
#include "token.h"
#include "lexer.h"

static bool is_operator(char c);
static bool is_number_status(LexerStatus lex_status);
static void set_operater_token(Token* token, char current_char);
static bool check_status_set_token(Token* token, LexerStatus lex_status, char current_char);
static bool check_char_set_status(LexerStatus* lex_status, char current_char);

static char* st_line;
static int st_line_pos;

const char* keyword[] = {
	"repeat", "loop",
	"goto", "gosub", "return",
	"if", ":",
	"pset", "color", "redraw", "title", "wait",
	"rnd",
	"key",
	";",
	"==",">=", ">", "<=", "<",
	"-", "+", "*", "/", "(", ")",
	"@"
};

void set_line(char* line) {
    st_line = line;
    st_line_pos = 0;
}

void get_token(Token* token) {
    int out_pos = 0;
    char current_char = ' ';
    LexerStatus lex_status = INITIAL_STATUS;
    token->group = BAD_TOKEN;
    
    while (st_line[st_line_pos] != '\0') {
        current_char = st_line[st_line_pos];
        
        // 字句解析器の状態をチェックしてトークンをセットする
        if (check_status_set_token(token, lex_status, current_char)) {
            return;
        }
        
        // 空白は無視して次に進む
        if (isspace(current_char)) {
            st_line_pos += 1;
            continue;
        }
        
        // トークンが長すぎる場合
        if (out_pos >= MAX_TOKEN_SIZE - 1) {
            fprintf(stderr, "トークンが長すぎます\n");
            exit(1);
        }
        
        // 1文字進める
        token->string[out_pos] = st_line[st_line_pos];
        token->string[out_pos + 1] = '\0';
        st_line_pos += 1;
        out_pos += 1;
        
        // 算術演算子なら算術演算子トークンを返す
        if (is_operator(current_char)) { //[\+\-\*\/]
            set_operater_token(token, current_char);
            return;
        }
        
        // 文字をチェックして状態をセットする
        if (check_char_set_status(&lex_status, current_char)) {
            continue;
        }
        
        fprintf(stderr, "不正な文字です:%c\n", current_char);
        exit(1);
    }
}

// 内部関数

static bool
is_operator(char c) {
    if (c == '+' || c == '-' || c == '*' || c == '/') {
        return true;
    } else {
        return false;
    }
}

static bool
is_number_status(LexerStatus lex_status) {
    if ((lex_status == INT_STATUS
        || lex_status == FRAC_STATUS)) {
        return true;
    } else {
        return false;
    }
}

static void
set_operater_token(Token* token, char current_char)
{
    if (current_char == '+') {
        token->group = ADD_TOKEN;
    } else if (current_char == '-') {
        token->group = SUB_TOKEN;
    } else if (current_char == '*') {
        token->group = MUL_TOKEN;
    } else if (current_char == '/') {
        token->group = DIV_TOKEN;
    } else {
    }
}

static bool
check_status_set_token(Token* token, LexerStatus lex_status, char current_char)
{
    if (st_line_pos == 0
        && current_char == ';')
    {
        token->group = COMMENT_TOKEN;
        return true;
    }
        
    if (is_number_status(lex_status)
        && !isdigit(current_char)
        && current_char != '.')
    {
        token->group = NUM_TOKEN;
        sscanf(token->string, "%lf", &token->value);
        return true;
    }
        
    if (lex_status == LP_STATUS) {
        if (!is_operator(current_char)
            && current_char != '.'
            && current_char != '=')
        {
            token->group = LP_TOKEN;
            return true;
        }
        else {
            fprintf(stderr, "シンタックスエラー\n");
            exit(1);
        }
    }
        
    if (lex_status == RP_STATUS) {
        if (current_char != '.'
            && current_char != '=')
        {
            token->group = RP_TOKEN;
            return true;
        }
        else {
            fprintf(stderr, "シンタックスエラー\n");
            exit(1);
        }
    }
        
    if (lex_status == EQUAL_STATUS) {
        token->group = EQUAL_TOKEN;
        return true;
    }
        
    if (current_char == '\n') {
        token->group = EOF_TOKEN;
        return true;
    }
    
    return false;
}

static bool
check_char_set_status(LexerStatus* lex_status, char current_char)
{
    if (isdigit(current_char)) { //[0-9]
        if (*lex_status == INITIAL_STATUS) {
            *lex_status = INT_STATUS;
        } else if (*lex_status == DOT_STATUS) {
            *lex_status = FRAC_STATUS;
        } else {}
        return true;
    }
        
    if (current_char == '(') {
        *lex_status = LP_STATUS;
        return true;
    }
        
    if (current_char == ')') {
        *lex_status = RP_STATUS;
        return true;
    }
        
    if (current_char == '=') {
        *lex_status = EQUAL_STATUS;
        return true;
    }
        
    if (current_char == '.') {
        if (*lex_status == INT_STATUS) {
            *lex_status = DOT_STATUS;
            return true;
        } else {
            fprintf(stderr, "シンタックスエラー\n");
            exit(1);
        }
    }
        
    if (current_char == '"') {
        if (*lex_status != STRING_STATUS) {
            *lex_status = STRING_STATUS;
            return true;
        } else {
        }
    }
        
    if (*lex_status == STRING_STATUS) {
        return true;
    }
    
    return false;
}

// テスト用コード
/*
void parse_line(char* buf) {
    Token token;
    
    set_line(buf);
    
    for (;;) {
        get_token(&token);
        if (token.group == EOF_TOKEN) {
            break;
        } else if (token.group == COMMENT_TOKEN) {
            printf("トークン:%d, 文字列:%s\n", token.group, token.string);
            break;
        } else {
            printf("トークン:%d, 文字列:%s\n", token.group, token.string);
        }
    }
}

int
main(int argc, char **argv) {
   char buf[1024];
    
    while (fgets(buf, 1024, stdin) != NULL) {
        parse_line(buf);
    }
	
	return 0;
}
*/