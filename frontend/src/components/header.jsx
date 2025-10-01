import { Avatar } from './ui/avatar';

export const Header = () => {
	return (
		<div className="py-2 bg-neutral-900">
			<div className="flex justify-between items-center m-auto container">
				<div>
					<img className="w-20" src="/logo.svg"></img>
				</div>

				<div className="text-white items-center text-lg flex gap-1">
					<Avatar></Avatar>Ivan Druzhinin{' '}
					<svg
						xmlns="http://www.w3.org/2000/svg"
						width="16"
						height="16"
						fill="currentColor"
						class="bi bi-chevron-down"
						viewBox="0 0 16 16"
					>
						<path
							fill-rule="evenodd"
							d="M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708"
						/>
					</svg>{' '}
				</div>
			</div>
		</div>
	);
};
