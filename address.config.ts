import { polygon } from 'viem/chains';
import { Address, zeroAddress } from 'viem';

export interface ChainAddress {
	membership: Address;

	// accept any optional key
	[key: string]: Address | undefined;
}

export const ADDRESS: Record<number, ChainAddress> = {
	[polygon.id]: {
		membership: '0xCd8e34A06e3F65B30cb76F690E7f54aFaf8D069c',
	},
};
