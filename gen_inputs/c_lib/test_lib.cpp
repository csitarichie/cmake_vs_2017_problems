#include "c_lib/test_lib.hpp"
#include "b_lib/test_lib.hpp"

const std::string& GenCLib::to_string()
{
    to_say.append("and I need:" + GenBLib.to_string())
    return to_say
}