{
   "tags" : [
      "crypto-cryptography-crypt-idea-blowfish-symmetric"
   ],
   "thumbnail" : "/images/_pub_2001_07_10_crypto/111-crypto.jpg",
   "categories" : "security",
   "image" : null,
   "title" : "Symmetric Cryptography in Perl",
   "date" : "2001-07-10T00:00:00-08:00",
   "authors" : [
      "abhijit-menon-sen"
   ],
   "draft" : null,
   "description" : " Having purchased the $250 cookie recipe from Neiman-Marcus, Alice wants to send it to Bob, but keep it away from Eve, who snoops on everyone's network traffic from the cubicle down the hall. How can Perl help her? Ciphers...",
   "slug" : "/pub/2001/07/10/crypto.html"
}



Having purchased the $250 cookie recipe from Neiman-Marcus, Alice wants to send it to Bob, but keep it away from Eve, who snoops on everyone's network traffic from the cubicle down the hall.

How can Perl help her?

### <span id="ciphers">Ciphers</span>

Cryptographic algorithms, or *ciphers*, offer Alice one way to protect her data. By encrypting the recipe before sending it over the network, she can render it useless to anyone but Bob, who alone possesses the secret information required to decrypt it.

Ciphers were once closely guarded secrets, but relying on the secrecy of an algorithm is a risky proposition. If your security were somehow compromised, adversaries could read all of your past messages, and (if you ever discovered the breach) you must find an entirely different algorithm to use in future.

Modern ciphers, usually publicly known and widely studied, rely on the secrecy of a *key* instead. They encrypt the same plaintext differently for each key; to decrypt a ciphertext, you must know the key used to produce it. New keys are easy to generate, so the compromise of a single key is a smaller problem. Although messages encrypted with the stolen key are rendered readable, the algorithm itself can be reused.

Algorithms that use the same key for both encryption and decryption are called *symmetric ciphers*. To use such an algorithm, Alice and Bob must agree on a key to use before they can exchange messages. Since decryption depends only on the knowledge of this key, they must ensure that they share the key by a *secure channel* that Eve cannot access (Alice could whisper the key into Bob's ear over dinner, for example).

Most well-known symmetric ciphers are *block ciphers*. The plaintext to be encrypted must be split into fixed-length blocks (usually 64 or 128 bits long) and fed to the cipher one at a time. The resulting blocks (of the same length) are concatenated to form the ciphertext.

The ciphers in widespread use today vary in strength, key length, block size and their approach to encrypting data. Some of the popular ciphers (IDEA, Twofish, Rijndael) are implemented by eponymous modules in the Crypt:: namespace on the CPAN (Crypt::IDEA and so on).

To decide which cipher to use for a particular application, one must consider the strength and speed required, and the computational resources available. The decision cannot be made without research, but IDEA is often considered the best practical choice for a general purpose cipher.

### <span id="keys">Keys</span>

Symmetric ciphers usually use randomly generated keys (typically between 64 and 256 bits in length), and computers are notoriously bad at truly random number generation. Fortunately, many modern systems have some support for the generation of cryptographically secure random numbers, ranging from expensive hardware to device drivers that gather entropy from the timing delay between interrupts.

Crypt::Random, available from the CPAN, is a convenient interface to the `/dev/random` device on many Unix systems. Once installed, it is simple to use:

        use Crypt::Random qw( makerandom );

        $key = makerandom( Size => 128, Strength => 1);

For cryptographic key generation, the `Strength` parameter should always be 1. The `Size` in bits of the desired key depends on the cipher you want to use the key with. Typical symmetric key sizes range from 128 to 256 bits.

### <span id="how can i use these in perl">How Can I Use These in Perl?</span>

The `Crypt` modules all support the same simple interface: `new($key)` creates a cipher object, and the `encrypt()` and `decrypt()` methods operate on single blocks of data. The responsibility for key generation and sharing, providing suitable blocks, and the transmission of the ciphertext, lies with the user. In the examples below, we will use the Crypt::Twofish module. Twofish is a free, unpatented 128-bit block cipher with a 128, 192, or 256-bit key.

        use Crypt::Twofish;

        # Create a new Crypt::Twofish object with the 128-bit key generated
        # above.
        $cipher = Crypt::Twofish->new($key);

        # Encrypt a block full of 0s...
        $ciphertext = $cipher->encrypt(pack "H*", "00"x16);

        # And then decrypt the result.
        print unpack "H*", $cipher->decrypt($ciphertext);

The implementation raises an important issue: What does one do with the second chunk of an 18-byte file? Twofish cannot operate on anything less than a 16-byte block, so *padding* must be added to the end of the last block to make it 16 bytes long. NULs (\\000) are usually used to pad the block, but the value used doesn't matter, because the padding is removed after the ciphertext is decrypted.

Alice can now use this code to encrypt her recipe:

        # Assume that $key contains a previously-generated key, and that
        # PLAINTEXT and CIPHERTEXT are filehandles opened for reading and
        # writing respectively.

        $cipher = Crypt::Twofish->new($key);

        while (read(PLAINTEXT, $block, 16)) {
            $len   = length $block;
            $size += $len;

            # Add padding if necessary
            $block .= "\000"x(16-$len) if $len < 16;

            $ciphertext .= $cipher->encrypt($block);
        }

        # Record the size of the plaintext, so that the recipient knows how
        # much padding to remove.
        print CIPHERTEXT "$size\n";
        print CIPHERTEXT $ciphertext;

The output of this program can be safely sent across the network to Bob, perhaps as an e-mail attachment. Bob, having received the secret key by some other means, can then use the following code to decrypt the message:

        $cipher = Crypt::Twofish->new($key);

        $size = <CIPHERTEXT>;

        while (read(CIPHERTEXT, $ct, 16)) {
            $pt .= $cipher->decrypt($ct);
        }

        # Write only $size bytes of the output; ignore padding.
        print PLAINTEXT substr($pt, 0, $size);

This is really all we need for symmetric cryptography in Perl. Using a different cipher is simply a matter of installing another module and changing the \`\`Twofish'' above. From a cryptographic perspective, however, there are still some problems we must consider.

### <span id="cipher modes">Cipher Modes</span>

The code above uses the Twofish cipher in Electronic Code Book (ECB) mode, meaning that `n`th ciphertext block depends only on the key and the `n`th plaintext block. For a particular key, one could build an exhaustive table (or Code Book) of plaintext blocks and their ciphertext counterparts. Then, instead of actually encrypting the plaintext, one could simply look at the relevant entries in the table to find the ciphertext.

Because of the highly repetitive nature of most texts, plaintext blocks and their corresponding blocks in the ciphertext tend to be repeated quite often. Further, it is often possible to make informed guesses about parts of the plaintext (Eve knows, for example, that Alice's messages all have a long Tolkien quote in the signature).

Given enough patience and ciphertext, Eve can start to build a code book that maps ciphertext blocks to plaintext ones. Then, without knowing either the algorithm or the key, she could simply look up the relevant blocks in the intercepted ciphertext and write down large parts of the original plaintext!

Several new cipher modes have been invented to address this problem. One of the most generally useful ones is Cipher Block Chaining. *CBC* starts by generating a random block (called an Initializ,ation Vector, or *IV*) and encrypting it. The first plaintext block is XORed with the encrypted IV before being encrypted. Thereafter, each block is XORed with the ciphertext of the block preceding it, and then encrypted.

Here, each ciphertext block depends on the preceding ciphertext block, and the plaintext blocks so far. Thus, the blocks must be decrypted in order, and none of the patterns displayed by ECB are present. The IV itself does not need to be kept secret, and is usually transmitted with the ciphertext like `$size` above.

Decryption of the ciphertext proceeds in the opposite order. The first ciphertext block is decrypted and XORed with the IV to form the first plaintext block, and each ciphertext block thereafter is XORed with the previous one to form a plaintext block. Other modes are similar in intent, but vary in detail, including the way errors in transmission affect the ciphertext, and the amount of feedback or dependency on previous blocks.

Alice and Bob could alter their code to perform cipher block chaining, but the handy Crypt::CBC module can save them the trouble. The module, available from the CPAN, is used in conjunction with a symmetric cipher module (like Crypt::Twofish). It handles padding, IV generation and all other details. The user only needs to specify a key, and the data to be encrypted or decrypted.

Thus, Alice could just do:

        use Crypt::CBC;
        $cipher = new Crypt::CBC ($key, 'Twofish');
        undef $/; $plaintext = <PLAINTEXT>;
        print CIPHERTEXT $cipher->encrypt($plaintext);

And Bob could do:

        use Crypt::CBC;
        $cipher = new Crypt::CBC ($key, 'Twofish');
        undef $/; $ciphertext = <CIPHERTEXT>;
        print PLAINTEXT $cipher->decrypt($ciphertext);

Much simpler!

------------------------------------------------------------------------

<span id="asymmetric cryptography">Asymmetric Cryptography</span>
=================================================================

Asymmetric (or public-key) ciphers use a pair of mathematically related keys, and the algorithms are so designed that data encrypted with one half of the key pair can only be decrypted by the other. Bob can generate a key pair and keep one half secret, while publishing the other half. Alice can then encrypt the recipe with Bob's public key, knowing that it can only be decrypted with the secret half. Although this eliminates the need to share keys over a secure channel, it has its problems, too. For one, most public key encryption schemes require much longer keys (often 2048 bits or more) and are much slower.

The `Crypt` namespace contains modules for public key cryptography as well. `Crypt::RSA` is a portable implementation of the (now free) RSA algorithm, one of the most widely studied public-key encryption schemes. There are interfaces to various versions of PGP (`Crypt::PGP2`, `Crypt::PGP5`, `Crypt::GPG`), as well as implementations of public-key based signature algorithms (`Crypt::DSA`).

------------------------------------------------------------------------

<span id="cryptanalysis">Cryptanalysis</span>
=============================================

Unfortunately, our implicit assumption that the ciphertext is useless to Eve is not always true. Depending on the information and resources that are available to her, she can try various means to retrieve the recipe. The simplest strategy is to try and guess the key Alice used. This is known as a *brute-force attack*, and involves repeatedly generating random keys and trying to decrypt the ciphertext with each one.

The effectiveness of this approach depends on the size of the key: the longer it is, the more possible keys there are, and the more guesses will be required, on average, to find the right one. Thus, the only possible defense is to use a key long enough to make a key search computationally impractical.

How long is a safe key? DES with 56-bit keys was recently cracked in a little less than a day, but the 128-bit keyspace (range of possible keys) is `4 * 10**21` times larger still. Although computing power is becoming cheaper, it seems likely that 128-bit keys will be safe from brute-force attacks for many years to come.

Of course, there are far more sophisticated attacks that they may be vulnerable to. As we saw in the description of ECB, cryptanalysts can often exploit patterns in the plaintext (long signatures, repeated phrases) or ciphertext (repeated blocks) to great advantage, or they may look for weaknesses (or exploit known ones) in the algorithm. Often, a combination of such techniques reduces the potential keyspace enough that a brute-force attack becomes practical.

Cryptanalysis and cryptographic techniques advanced hand-in-hand; new ciphers are designed to withstand old attacks, and newer attacks are attempted all the time. This makes it very important to stay abreast of current advances in cryptographic technology if you are serious about protecting your data for long periods of time.

------------------------------------------------------------------------

<span id="further resources">Further Resources</span>
=====================================================

**<span id="item_google%2Ecom">google.com</span>**
  
The Great God Google knows enough about cryptography-related material to keep you occupied for a considerable amount of time.

**<span id="item_perl%2Dcrypto%2Dsubscribe%40perl%2Eorg"></span><perl-crypto-subscribe@perl.org>**
  
The perl-crypto mailing list, although not very active at the moment, is intended for discussion of all aspects (both user and developer level) of cryptography with Perl.

**<span id="item_Crypt%3A%3ATwofish">Crypt::Twofish</span>**
  
The Crypt::Twofish module, which has benefited from the inputs of several people, is a good example of how to write a portable cipher implementation.


