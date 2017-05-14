#include "first_lib.h"
#include "a_lib/test_lib.hpp"

#include <iostream>

int main()
{
    std::cout << "First test : I need :" << FirstLib().to_string() << " and " << GenALib().to_string();
    return 0;
}
