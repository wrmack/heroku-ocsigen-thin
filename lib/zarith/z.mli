(* This file was automatically generated by z_pp.pl from z.mlip *)  (**
   Integers.

   This modules provides arbitrary-precision integers.
   Small integers internally use a regular OCaml [int].
   When numbers grow too large, we switch transparently to GMP numbers
   ([mpn] numbers fully allocated on the OCaml heap).

   This interface is rather similar to that of [Int32] and [Int64],
   with some additional functions provided natively by GMP
   (GCD, square root, pop-count, etc.).


   This file is part of the Zarith library
   http://forge.ocamlcore.org/projects/zarith .
   It is distributed under LGPL 2 licensing, with static linking exception.
   See the LICENSE file included in the distribution.

   Copyright (c) 2010-2011 Antoine Miné, Abstraction project.
   Abstraction is part of the LIENS (Laboratoire d'Informatique de l'ENS),
   a joint laboratory by:
   CNRS (Centre national de la recherche scientifique, France),
   ENS (École normale supérieure, Paris, France),
   INRIA Rocquencourt (Institut national de recherche en informatique, France).

 *)


(** {1 Toplevel} *)

(** For an optimal experience with the [ocaml] interactive toplevel,
    the magic commands are:

    {[
    #load "zarith.cma";;
    #install_printer Z.pp_print;;
    ]}

    Alternatively, using the new [Zarith_top] toplevel module, simply:
    {[
    #require "zarith.top";;
    ]}
*)



(** {1 Types} *)

type t
(** Type of integers of arbitrary length. *)

exception Overflow
(** Raised by conversion functions when the value cannot be represented in
    the destination type.
 *)

(** {1 Construction} *)

val zero: t
(** The number 0. *)

val one: t
(** The number 1. *)

val minus_one: t
(** The number -1. *)

external of_int: int -> t = "ml_z_of_int" [@@noalloc]
(** Converts from a base integer. *)

external of_int32: int32 -> t = "ml_z_of_int32"
(** Converts from a 32-bit integer. *)

external of_int64: int64 -> t = "ml_z_of_int64"
(** Converts from a 64-bit integer. *)

external of_nativeint: nativeint -> t = "ml_z_of_nativeint"
(** Converts from a native integer. *)

external of_float: float -> t = "ml_z_of_float"
(** Converts from a floating-point value.
    The value is truncated (rounded towards zero).
    Raises [Overflow] on infinity and NaN arguments.
 *)

val of_string: string -> t
(** Converts a string to an integer.
    An optional [-] prefix indicates a negative number, while a [+]
    prefix is ignored.
    An optional prefix [0x], [0o], or [0b] (following the optional [-]
    or [+] prefix) indicates that the number is,
    represented, in hexadecimal, octal, or binary, respectively.
    Otherwise, base 10 is assumed.
    (Unlike C, a lone [0] prefix does not denote octal.)
    Raises an [Invalid_argument] exception if the string is not a
    syntactically correct representation of an integer.
 *)

val of_substring : string -> pos:int -> len:int -> t
(** [of_substring s ~pos ~len] is the same as [of_string (String.sub s
    pos len)]
 *)

val of_string_base: int -> string -> t
(** Parses a number represented as a string in the specified base,
    with optional [-] or [+] prefix.
    The base must be between 2 and 16.
 *)

external of_substring_base
  : int -> string -> pos:int -> len:int -> t
  = "ml_z_of_substring_base"
(** [of_substring_base base s ~pos ~len] is the same as [of_string_base
    base (String.sub s pos len)]
*)


(** {1 Basic arithmetic operations} *)

external succ: t -> t = "ml_z_succ" "ml_as_z_succ"
(** Returns its argument plus one. *)

external pred: t -> t = "ml_z_pred" "ml_as_z_pred"
(** Returns its argument minus one. *)

external abs: t -> t = "ml_z_abs" "ml_as_z_abs"
(** Absolute value. *)

external neg: t -> t = "ml_z_neg" "ml_as_z_neg"
(** Unary negation. *)

external add: t -> t -> t = "ml_z_add" "ml_as_z_add"
(** Addition. *)

external sub: t -> t -> t = "ml_z_sub" "ml_as_z_sub"
(** Subtraction. *)

external mul: t -> t -> t = "ml_z_mul" "ml_as_z_mul"
(** Multiplication. *)

external div: t -> t -> t = "ml_z_div" "ml_as_z_div"
(** Integer division. The result is truncated towards zero
    and obeys the rule of signs.
    Raises [Division_by_zero] if the divisor (second argument) is 0.
 *)

external rem: t -> t -> t = "ml_z_rem" "ml_as_z_rem"
(** Integer remainder. Can raise a [Division_by_zero].
    The result of [rem a b] has the sign of [a], and its absolute value is
    strictly smaller than the absolute value of [b].
    The result satisfies the equality [a = b * div a b + rem a b].
 *)

external div_rem: t -> t -> (t * t) = "ml_z_div_rem"
(** Computes both the integer quotient and the remainder.
    [div_rem a b] is equal to [(div a b, rem a b)].
    Raises [Division_by_zero] if [b = 0].
 *)

external cdiv: t -> t -> t = "ml_z_cdiv"
(** Integer division with rounding towards +oo (ceiling).
    Can raise a [Division_by_zero].
 *)

external fdiv: t -> t -> t = "ml_z_fdiv"
(** Integer division with rounding towards -oo (floor).
    Can raise a [Division_by_zero].
 *)

val ediv_rem: t -> t -> (t * t)
(** Euclidean division and remainder.  [ediv_rem a b] returns a pair [(q, r)]
    such that [a = b * q + r] and [0 <= r < |b|].
    Raises [Division_by_zero] if [b = 0].
 *)

val ediv: t -> t -> t
(** Euclidean division. [ediv a b] is equal to [fst (ediv_rem a b)].
    The result satisfies [0 <= a - b * ediv a b < |b|].
    Raises [Division_by_zero] if [b = 0].
 *)

val erem: t -> t -> t
(** Euclidean remainder.  [erem a b] is equal to [snd (ediv_rem a b)].
    The result satisfies [0 <= erem a b < |b|] and
    [a = b * ediv a b + erem a b].  Raises [Division_by_zero] if [b = 0].
 *)

external divexact: t -> t -> t = "ml_z_divexact" "ml_as_z_divexact"
(** [divexact a b] divides [a] by [b], only producing correct result when the
    division is exact, i.e., when [b] evenly divides [a].
    It should be faster than general division.
    Can raise a [Division_by_zero].
*)


(** {1 Bit-level operations} *)

(** For all bit-level operations, negative numbers are considered in 2's
    complement representation, starting with a virtual infinite number of
    1s.
 *)

external logand: t -> t -> t = "ml_z_logand" "ml_as_z_logand"
(** Bitwise logical and. *)

external logor: t -> t -> t = "ml_z_logor" "ml_as_z_logor"
(** Bitwise logical or. *)

external logxor: t -> t -> t = "ml_z_logxor" "ml_as_z_logxor"
(** Bitwise logical exclusive or. *)

external lognot: t -> t = "ml_z_lognot" "ml_as_z_lognot"
(** Bitwise logical negation.
    The identity [lognot a]=[-a-1] always hold.
 *)

external shift_left: t -> int -> t = "ml_z_shift_left" "ml_as_z_shift_left"
(** Shifts to the left.
    Equivalent to a multiplication by a power of 2.
    The second argument must be non-negative.
 *)

external shift_right: t -> int -> t = "ml_z_shift_right" "ml_as_z_shift_right"
(** Shifts to the right.
    This is an arithmetic shift,
    equivalent to a division by a power of 2 with rounding towards -oo.
    The second argument must be non-negative.
 *)

external shift_right_trunc: t -> int -> t = "ml_z_shift_right_trunc"
(** Shifts to the right, rounding towards 0.
    This is equivalent to a division by a power of 2, with truncation.
    The second argument must be non-negative.
 *)

external numbits: t -> int = "ml_z_numbits" [@@noalloc]
(** Returns the number of significant bits in the given number.
    If [x] is zero, [numbits x] returns 0.  Otherwise,
    [numbits x] returns a positive integer [n] such that
    [2^{n-1} <= |x| < 2^n].  Note that [numbits] is defined
    for negative arguments, and that [numbits (-x) = numbits x]. *)

external trailing_zeros: t -> int = "ml_z_trailing_zeros" [@@noalloc]
(** Returns the number of trailing 0 bits in the given number.
    If [x] is zero, [trailing_zeros x] returns [max_int].
    Otherwise, [trailing_zeros x] returns a nonnegative integer [n]
    which is the largest [n] such that [2^n] divides [x] evenly.
    Note that [trailing_zeros] is defined for negative arguments,
    and that [trailing_zeros (-x) = trailing_zeros x]. *)

val testbit: t -> int -> bool
(** [testbit x n] return the value of bit number [n] in [x]:
    [true] if the bit is 1, [false] if the bit is 0.
    Bits are numbered from 0.  Raise [Invalid_argument] if [n]
    is negative. *)

external popcount: t -> int = "ml_z_popcount"
(** Counts the number of bits set.
    Raises [Overflow] for negative arguments, as those have an infinite
    number of bits set.
 *)

external hamdist: t -> t -> int = "ml_z_hamdist"
(** Counts the number of different bits.
    Raises [Overflow] if the arguments have different signs
    (in which case the distance is infinite).
 *)

(** {1 Conversions} *)

(** Note that, when converting to an integer type that cannot represent the
    converted value, an [Overflow] exception is raised.
 *)

external to_int: t -> int = "ml_z_to_int"
(** Converts to a base integer. May raise [Overflow]. *)

external to_int32: t -> int32 = "ml_z_to_int32"
(** Converts to a 32-bit integer. May raise [Overflow]. *)

external to_int64: t -> int64 = "ml_z_to_int64"
(** Converts to a 64-bit integer. May raise [Overflow]. *)

external to_nativeint: t -> nativeint = "ml_z_to_nativeint"
(** Converts to a native integer. May raise [Overflow]. *)

val to_float: t -> float
(** Converts to a floating-point value.
    This function rounds the given integer according to the current
    rounding mode of the processor.  In default mode, it returns
    the floating-point number nearest to the given integer,
    breaking ties by rounding to even. *)

val to_string: t -> string
(** Gives a human-readable, decimal string representation of the argument. *)

external format: string -> t -> string = "ml_z_format"
(** Gives a string representation of the argument in the specified
    printf-like format.
    The general specification has the following form:

    [% \[flags\] \[width\] type]

    Where the type actually indicates the base:

    - [i], [d], [u]: decimal
    - [b]: binary
    - [o]: octal
    - [x]: lowercase hexadecimal
    - [X]: uppercase hexadecimal

    Supported flags are:

    - [+]: prefix positive numbers with a [+] sign
    - space: prefix positive numbers with a space
    - [-]: left-justify (default is right justification)
    - [0]: pad with zeroes (instead of spaces)
    - [#]: alternate formatting (actually, simply output a literal-like prefix: [0x], [0b], [0o])

    Unlike the classic [printf], all numbers are signed (even hexadecimal ones),
    there is no precision field, and characters that are not part of the format
    are simply ignored (and not copied in the output).
 *)

external fits_int: t -> bool = "ml_z_fits_int" [@@noalloc]
(** Whether the argument fits in a regular [int]. *)

external fits_int32: t -> bool = "ml_z_fits_int32" [@@noalloc]
(** Whether the argument fits in an [int32]. *)

external fits_int64: t -> bool = "ml_z_fits_int64" [@@noalloc]
(** Whether the argument fits in an [int64]. *)

external fits_nativeint: t -> bool = "ml_z_fits_nativeint" [@@noalloc]
(** Whether the argument fits in a [nativeint]. *)


(** {1 Printing} *)

val print: t -> unit
(** Prints the argument on the standard output. *)

val output: out_channel -> t -> unit
(** Prints the argument on the specified channel.
    Also intended to be used as [%a] format printer in [Printf.printf].
 *)

val sprint: unit -> t -> string
(** To be used as [%a] format printer in [Printf.sprintf]. *)

val bprint: Buffer.t -> t -> unit
(** To be used as [%a] format printer in [Printf.bprintf]. *)

val pp_print: Format.formatter -> t -> unit
(** Prints the argument on the specified formatter.
    Can be used as [%a] format printer in [Format.printf] and as
    argument to [#install_printer] in the top-level.
 *)


(** {1 Ordering} *)

external compare: t -> t -> int = "ml_z_compare" [@@noalloc]
(** Comparison.  [compare x y] returns 0 if [x] equals [y],
    -1 if [x] is smaller than [y], and 1 if [x] is greater than [y].

    Note that Pervasive.compare can be used to compare reliably two integers
    only on OCaml 3.12.1 and later versions.
 *)

external equal: t -> t -> bool = "ml_z_equal" [@@noalloc]
(** Equality test. *)

val leq: t -> t -> bool
(** Less than or equal. *)

val geq: t -> t -> bool
(** Greater than or equal. *)

val lt: t -> t -> bool
(** Less than (and not equal). *)

val gt: t -> t -> bool
(** Greater than (and not equal). *)

external sign: t -> int = "ml_z_sign" [@@noalloc]
(** Returns -1, 0, or 1 when the argument is respectively negative, null, or
    positive.
 *)

val min: t -> t -> t
(** Returns the minimum of its arguments. *)

val max: t -> t -> t
(** Returns the maximum of its arguments. *)

val is_even: t -> bool
(** Returns true if the argument is even (divisible by 2), false if odd. *)

val is_odd: t -> bool
(** Returns true if the argument is odd, false if even. *)

external hash: t -> int = "ml_z_hash" [@@noalloc]
(** Hashes a number.
    This functions gives the same result as OCaml's polymorphic hashing
    function.
    The result is consistent with equality: if [a] = [b], then [hash a] =
    [hash b].
 *)

(** {1 Elementary number theory} *)

external gcd: t -> t -> t = "ml_z_gcd"
(** Greatest common divisor.
    The result is always positive.
    Raises a [Division_by_zero] is either argument is null.
*)

val gcdext: t -> t -> (t * t * t)
(** [gcdext u v] returns [(g,s,t)]  where [g] is the greatest common divisor
    and [g=us+vt].
    [g] is always positive.
    Raises a [Division_by_zero] is either argument is null.

    Note: the function is based on the GMP [mpn_gcdext] function. The exact choice of [s] and [t] such that [g=us+vt] is not specified, as it may vary from a version of GMP to another (it has changed notably in GMP 4.3.0 and 4.3.1).
 *)

val lcm: t -> t -> t
(**
    Least common multiple.
    The result is always positive.
    Raises a [Division_by_zero] is either argument is null.
 *)

external powm: t -> t -> t -> t = "ml_z_powm"
(** [powm base exp mod] computes [base]^[exp] modulo [mod].
    Negative [exp] are supported, in which case ([base]^-1)^(-[exp]) modulo
    [mod] is computed.
    However, if [exp] is negative but [base] has no inverse modulo [mod], then
    a [Division_by_zero] is raised.
 *)

external powm_sec: t -> t -> t -> t = "ml_z_powm_sec"
(** [powm_sec base exp mod] computes [base]^[exp] modulo [mod].
    Unlike [Z.powm], this function is designed to take the same time
    and have the same cache access patterns for any two same-size
    arguments.  Used in cryptographic applications, it provides better
    resistance to side-channel attacks than [Z.powm].
    The exponent [exp] must be positive, and the modulus [mod]
    must be odd.  Otherwise, [Invalid_arg] is raised. *)

external invert: t -> t -> t = "ml_z_invert"
(** [invert base mod] returns the inverse of [base] modulo [mod].
    Raises a [Division_by_zero] if [base] is not invertible modulo [mod].
 *)

external probab_prime: t -> int -> int = "ml_z_probab_prime"
(** [probab_prime x r] returns 0 if [x] is definitely composite,
    1 if [x] is probably prime, and 2 if [x] is definitely prime.
    The [r] argument controls how many Miller-Rabin probabilistic
    primality tests are performed (5 to 10 is a reasonable value).
 *)

external nextprime: t -> t = "ml_z_nextprime"
(** Returns the next prime greater than the argument.
    The result is only prime with very high probability.
 *)


(** {1 Powers} *)

external pow: t -> int -> t = "ml_z_pow"
(** [pow base exp] raises [base] to the [exp] power.
    [exp] must be non-negative.
    Note that only exponents fitting in a machine integer are supported, as
    larger exponents would surely make the result's size overflow the
    address space.
 *)

external sqrt: t -> t = "ml_z_sqrt"
(** Returns the square root. The result is truncated (rounded down
    to an integer).
    Raises an [Invalid_argument] on negative arguments.
 *)

external sqrt_rem: t -> (t * t) = "ml_z_sqrt_rem"
(** Returns the square root truncated, and the remainder.
    Raises an [Invalid_argument] on negative arguments.
 *)

external root: t -> int -> t = "ml_z_root"
(** [root base n] computes the [n]-th root of [exp].
    [n] must be non-negative.
 *)

external perfect_power: t -> bool = "ml_z_perfect_power"
(** True if the argument has the form [a^b], with [b>1] *)

external perfect_square: t -> bool = "ml_z_perfect_square"
(** True if the argument has the form [a^2]. *)

val log2: t -> int
(** Returns the base-2 logarithm of its argument, rounded down to
    an integer.  If [x] is positive, [log2 x] returns the largest [n]
    such that [2^n <= x].  If [x] is negative or zero, [log2 x] raise
    the [Invalid_argument] exception. *)

val log2up: t -> int
(** Returns the base-2 logarithm of its argument, rounded up to
    an integer.  If [x] is positive, [log2up x] returns the smallest [n]
    such that [x <= 2^n].  If [x] is negative or zero, [log2up x] raise
    the [Invalid_argument] exception. *)

(** {1 Representation} *)

external size: t -> int = "ml_z_size" [@@noalloc]
(** Returns the number of machine words used to represent the number. *)

external extract: t -> int -> int -> t = "ml_z_extract"
(** [extract a off len] returns a non-negative number corresponding to bits
    [off] to [off]+[len]-1 of [b].
    Negative [a] are considered in infinite-length 2's complement
    representation.
 *)

val signed_extract: t -> int -> int -> t
(** [signed_extract a off len] extracts bits [off] to [off]+[len]-1 of [b],
    as [extract] does, then sign-extends bit [len-1] of the result
    (that is, bit [off + len - 1] of [a]).  The result is between
    [- 2{^[len]-1}] (included) and [2{^[len]-1}] (excluded),
    and equal to [extract a off len] modulo [2{^len}].
 *)

external to_bits: t -> string = "ml_z_to_bits"
(** Returns a binary representation of the argument.
    The string result should be interpreted as a sequence of bytes,
    corresponding to the binary representation of the absolute value of
    the argument in little endian ordering.
    The sign is not stored in the string.
 *)

external of_bits: string -> t = "ml_z_of_bits"
(** Constructs a number from a binary string representation.
    The string is interpreted as a sequence of bytes in little endian order,
    and the result is always positive.
    We have the identity: [of_bits (to_bits x) = abs x].
    However, we can have [to_bits (of_bits s) <> s] due to the presence of
    trailing zeros in s.
 *)


(** {1 Prefix and infix operators} *)

(**
   Classic (and less classic) prefix and infix [int] operators are
   redefined on [t].

   This makes it easy to typeset expressions.
   Using OCaml 3.12's local open, you can simply write
   [Z.(~$2 + ~$5 * ~$10)].
 *)

external (~-): t -> t = "ml_z_neg" "ml_as_z_neg"
(** Negation [neg]. *)

val (~+): t -> t
(** Identity. *)

external (+): t -> t -> t = "ml_z_add" "ml_as_z_add"
(** Addition [add]. *)

external (-): t -> t -> t = "ml_z_sub" "ml_as_z_sub"
(** Subtraction [sub]. *)

external ( * ): t -> t -> t = "ml_z_mul" "ml_as_z_mul"
(** Multiplication [mul]. *)

external (/): t -> t -> t = "ml_z_div" "ml_as_z_div"
(** Truncated division [div]. *)

external (/>): t -> t -> t = "ml_z_cdiv"
(** Ceiling division [cdiv]. *)

external (/<): t -> t -> t = "ml_z_fdiv"
(** Flooring division [fdiv]. *)

external (/|): t -> t -> t = "ml_z_divexact" "ml_as_z_divexact"
(** Exact division [div_exact]. *)

external (mod): t -> t -> t = "ml_z_rem" "ml_as_z_rem"
(** Remainder [rem]. *)

external (land): t -> t -> t = "ml_z_logand" "ml_as_z_logand"
(** Bit-wise logical and [logand]. *)

external (lor): t -> t -> t = "ml_z_logor" "ml_as_z_logor"
(** Bit-wise logical inclusive or [logor]. *)

external (lxor): t -> t -> t = "ml_z_logxor" "ml_as_z_logxor"
(** Bit-wise logical exclusive or [logxor]. *)

external (~!): t -> t = "ml_z_lognot" "ml_as_z_lognot"
(** Bit-wise logical negation [lognot]. *)

external (lsl): t -> int -> t = "ml_z_shift_left" "ml_as_z_shift_left"
(** Bit-wise shift to the left [shift_left]. *)

external (asr): t -> int -> t = "ml_z_shift_right" "ml_as_z_shift_right"
(** Bit-wise shift to the right [shift_right]. *)

external (~$): int -> t = "ml_z_of_int" [@@noalloc]
(** Conversion from [int] [of_int]. *)

external ( ** ): t -> int -> t = "ml_z_pow"
(** Power [pow]. *)

module Compare : sig

    val (=): t -> t -> bool
    (** Same as [equal]. *)

    val (<): t -> t -> bool
    (** Same as [lt]. *)

    val (>): t -> t -> bool
    (** Same as [gt]. *)

    val (<=): t -> t -> bool
    (** Same as [leq]. *)

    val (>=): t -> t -> bool
    (** Same as [geq]. *)

    val (<>): t -> t -> bool
    (** [a <> b] is equivalent to [not (equal a b)]. *)

end

(** {1 Miscellaneous} *)

val version: string
(** Library version (this file refers to version ["1.9.1"]). *)

(**/**)

(** For internal use in module [Q]. *)
val round_to_float: t -> bool -> float
