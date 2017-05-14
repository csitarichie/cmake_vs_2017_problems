#include "second_lib.h"
#include "b_lib/test_lib.hpp"
#include "a_lib/test_lib.hpp"

#include <iostream>

int main()
{
    std::cout << "Second test : I need :" << SecondLib().to_string() << "and" << GenBLib().to_string() << "and" << GenALib().to_string();
    return 0;
}
