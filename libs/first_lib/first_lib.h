#pragma once

#include <string>

class FirstLib
{
public:
    const std::string& to_string() const { return to_say; }
    const std::string to_say = { "I'm FirstLib" };
};