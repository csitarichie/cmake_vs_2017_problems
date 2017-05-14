# cmake_vs_2017_problems
a small project to reproduce cmake problems in VS2017 enviroment

Meaning of floders :
====================

#1 gen_inputs: representing soruce files for the generator all files with *.gensrc
   The gen.cmake describes the depnednecies of a generated lib if it needs other gen libs

#2 generator: icludes generaotr and test for generator
   The src contains the generator executable this case is is a simple batch copy
   The test folder contains Ctest parsed test executables and they building
   the test.cmake describes what dependency the test has in termps of libs.

#3 libs: normal c++ libs. just for testing that normal libs are behavbing correctly.

Plrobems with VS2017 15.3
=========================

#1 the C test not getting reconised by visual studio
   even they exist and can be executed like :
   Go to Traget folder than in \build\x64-Debug-MSbuild\generator\test
   folder run ctest -C debug
   The outout shall be someting like this :
   `/build/x64-Debug-MSbuild/generator/test
    Start 1: 3rd
    1/3 Test #1: 3rd ..............................   Passed    0.05 sec
    Start 2: first
    2/3 Test #2: first ............................   Passed    0.05 sec
    Start 3: second
    3/3 Test #3: second ...........................   Passed    0.04 sec

    100% tests passed, 0 tests failed out of 3

    Total Test time (real) =   0.15 sec`
    
#2 when target like first.exe is exevuted the generator is allways triggerd.
see more detailed discussion in :
https://developercommunity.visualstudio.com/content/problem/55629/update-from-vs-2017-151-to-152-and-153-preview-bro.html

