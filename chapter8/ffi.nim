proc printf(format: cstring): cint {.importc,
                                     header: "stdio.h",
                                     varargs,
                                     discardable.}

printf("Amount of %s: %d out of %d\n", "ingredients", 5, 7)
