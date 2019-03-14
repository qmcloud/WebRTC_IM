package com.goim.bootstrap;

public class BruteForceCoding {

	private static byte byteVal = 101; // one hundred and one
	private static short shortVal = 10001; // ten thousand and one
	private static int intVal = 100000001; // one hundred million and one
	private static long longVal = 1000000000001L;// one trillion and one

	public final static int BSIZE = Byte.SIZE / Byte.SIZE;
	public final static int SSIZE = Short.SIZE / Byte.SIZE;
	public final static int ISIZE = Integer.SIZE / Byte.SIZE;
	public final static int LSIZE = Long.SIZE / Byte.SIZE;

	public final static int BYTEMASK = 0xFF; // 8 bits

	public static String byteArrayToDecimalString(byte[] bArray) {
		StringBuilder rtn = new StringBuilder();
		for (byte b : bArray) {
			rtn.append(b & BYTEMASK).append(" ");
		}
		return rtn.toString();
	}

	// Warning: Untested preconditions (e.g., 0 <= size <= 8)
	public static int encodeIntBigEndian(byte[] dst, long val, int offset, int size) {
		for (int i = 0; i < size; i++) {
			dst[offset++] = (byte) (val >> ((size - i - 1) * Byte.SIZE));
		}
		return offset;
	}

	// Warning: Untested preconditions (e.g., 0 <= size <= 8)
	public static long decodeIntBigEndian(byte[] val, int offset, int size) {
		long rtn = 0;
		for (int i = 0; i < size; i++) {
			rtn = (rtn << Byte.SIZE) | ((long) val[offset + i] & BYTEMASK);
		}
		return rtn;
	}

	/**
	 * An empty instance.
	 */
	public static final byte[] EMPTY_BYTE_ARRAY = new byte[0];

	/**
	 * @param a
	 * lower half
	 * @param b
	 * upper half
	 * @return New array that has a in lower half and b in upper half.
	 */
	public static byte[] add(final byte[] a, final byte[] b) {
		return add(a, b, BruteForceCoding.EMPTY_BYTE_ARRAY);
	}

	/**
	 * @param a
	 * first third
	 * @param b
	 * second third
	 * @param c
	 * third third
	 * @return New array made from a, b and c
	 */
	public static byte[] add(final byte[] a, final byte[] b, final byte[] c) {
		byte[] result = new byte[a.length + b.length + c.length];
		System.arraycopy(a, 0, result, 0, a.length);
		System.arraycopy(b, 0, result, a.length, b.length);
		System.arraycopy(c, 0, result, a.length + b.length, c.length);
		return result;
	}

	/**
	 * @param a
	 *            array
	 * @param length
	 *            amount of bytes to snarf
	 * @return Last <code>length</code> bytes from <code>a</code>
	 */
	public static byte[] tail(final byte[] a, final int length) {
		if (a.length < length) {
			return null;
		}
		byte[] result = new byte[length];
		System.arraycopy(a, a.length - length, result, 0, length);
		return result;
	}
	
	/**
	 * @param a
	 *            array
	 * @param length
	 *            amount of bytes to snarf
	 * @return Last <code>length</code> bytes from <code>a</code>
	 */
	public static byte[] tail(final byte[] a,final int beginPos, final int length) {
		if (a.length < length) {
			return null;
		}
		byte[] result = new byte[length];
		System.arraycopy(a, beginPos, result, 0, length);
		return result;
	}

	public static void main(String[] args) {
		byte[] message = new byte[BSIZE + SSIZE + ISIZE + LSIZE];
		// Encode the fields in the target byte array
		int offset = encodeIntBigEndian(message, byteVal, 0, BSIZE);
		offset = encodeIntBigEndian(message, shortVal, offset, SSIZE);
		offset = encodeIntBigEndian(message, intVal, offset, ISIZE);
		encodeIntBigEndian(message, longVal, offset, LSIZE);
		System.out.println("Encoded message: " + byteArrayToDecimalString(message));

		// Decode several fields
		long value = decodeIntBigEndian(message, BSIZE, SSIZE);
		System.out.println("Decoded short = " + value);
		value = decodeIntBigEndian(message, BSIZE + SSIZE + ISIZE, LSIZE);
		System.out.println("Decoded long = " + value);

		// Demonstrate dangers of conversion
		offset = 4;
		value = decodeIntBigEndian(message, offset, BSIZE);
		System.out.println("Decoded value (offset " + offset + ", size " + BSIZE + ") = " + value);
		byte bVal = (byte) decodeIntBigEndian(message, offset, BSIZE);
		System.out.println("Same value as byte = " + bVal);
	}

}
