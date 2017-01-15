#include "utility_string.h"

bool is_equal_string(const char* s1, const char* s2) {
    if (strcmp(s1, s2) == 0) {
        return true;
    } else {
        return false;
    }
}
