# TermsConditionsGenerator

# Installation
To run the app cd to the app directory and start irb, then run the following commands:
* load 'tc_generator.rb'
* TCGenerator.new(template_location: <your_template_location>, clauses_file_location: <your_clauses_location>, sections_file_location: <your_sections_location>).generate_document(<target_location>)

# Test files
To run spec files that are written using Rspec library, navigate to app directory and run
* bundle exec rspec spec

# Design Decisions
* I used Rspec as it's reliable library and well known for writing test files
* Took nearly 7 hours to finish it
* If there was more time, I would add more test files to test every class with a lot of various scenarios but since the main class is tested which is "tc_generator.rb" testing touches every class.
