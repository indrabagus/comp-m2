#ifndef NONINTERACTIVE_MODE_H
#define NONINTERACTIVE_MODE_H

#include <string>
#include <vector>

#include "computer.hpp"
#include "load.hpp"
#include "pipe_input.hpp"
#include "standard_output.hpp"

using namespace std;

class Ram;

class NoninteractiveMode {
  public:
    NoninteractiveMode(vector<string> filenamesIn, bool outputNumbers, 
                       bool outputChars, bool inputChars, bool rawInput) 
        : computerChain(vector<Computer>(filenamesIn.size())),
          output(StandardOutput(outputNumbers, outputChars)),
          input(PipeInput(inputChars, rawInput))
    { 
      // Fills rams with contents of files.
      for (size_t i = 0; i < filenamesIn.size(); i++) {
        Load::fillRamWithFile(filenamesIn[i].c_str(), computerChain[i].ram);
      }
      // Connects input, computers and output into chain.
      computerChain[0].ram.input = &input;
      for (size_t i = 1; i < computerChain.size(); i++) {
        computerChain[i].ram.input = &computerChain[i-1];
      }
      output.input = &computerChain.back();
    }

    void run();

  private:
    vector<Computer> computerChain;
    StandardOutput output;
    PipeInput input;
};

#endif