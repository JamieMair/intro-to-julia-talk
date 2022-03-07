# Introduction to Julia for researchers
 
 This GitHub repository contains code samples and slides for a talk about the Julia Programming Language, aimed at research academics who currently use tools such as Python and MATLAB for their research projects.

 ## Why Julia?


Before we even start talking about Julia, we first need to justify why it is even worth our time. As researchers, we care more results and the algorithms, rather than the implementation details like "what language was it written it?". Learning a new language can be very time-consuming, and often frustrating, so that's why we are going to take a bit of time to discuss the *why*. 

The [documentation](https://julialang.org/) for Julia spends quite a while justifying the existence of the language, and it is a good read which goes into a lot of detail. Here, I will try and summarise the key points.

### *If languages like Python and MATLAB already have support for numerical computing, why should we use Julia?*
This is a very good question. MATLAB has excellent support for most numerical computing requirements and is simple and easy to use. Python has an extensive library of packages to solve almost any problem in numerical computing and is rapidly becoming the industry standard for most research. However, these languages still face what is known as the **two-language problem**: Programmers develop their code in a dynamic language like Python or MATLAB, but when they require increased performance, they are usually forced to port (or rewrite) their code in a faster, harder to use language, such as C/C++ or Fortran. This is often the accepted norm - dynamic languages tend to be quite slow, especially when compared to C or Fortran. Nowadays, there are many ways around this, and usually most performance intensive tasks are offloaded to other packages (such as to numpy in Python). However, for the few cases where this compromise is not possible, there is little other choice than writing the slow parts of your code in a different language. Julia, by design, attempts to "solve" this problem, by providing a simple to use, dynamic, language which allows for faster development, while at the same time making it easy to rival the speeds achieved in languages like C or Fortran. Instead of having to learn two different languages, one can simply develop all of their code in Julia, and then it is often trivial to optimise your code to run fast, if it does not run quickly to begin with.

### *What is special about Julia?*

Julia was first created in 2012, and was designed from the ground up with performance in mind. From the Julia website, they list the following notable features:
- **Multiple dispatch** - this provides the ability to define function behaviour depending on the type of the input arguments. This is the backbone of the Julia language, and allows for the code to be general and reusable, while also allowing for great performance.
- **Dynamic type system** - this combines with multiple dispatch.
- **High-performance** - approaches the performance of statically typed languages such as C or Fortran.
- **Built-in package manager**
- **Interop facilities** - the language has many great features for interacting with different languages. There is the ability to call C functions directly with no wrappers or special APIs. There are also well-supported packages for calling Python with PyCall, R with RCall and Java/Scala with JavaCall.
- **Designed for parallel and distributed computing**
- **Lightweight threading**
- User defined types are as fast and compact as built-ins.
- The language is Free and Open Source.
- Automatic code generation of efficient and specialised code for different argument types.
- Efficient support for unicode symbols.

### Conclusions

Many examples of the benefits will be showcased in the slides and in the code examples given. It is worth going through these to get a more concrete view of why Julia is a good language to learn.