import { Routes, Route, BrowserRouter } from 'react-router-dom';
import App from '../pages/App';
import Profile from '../pages/Profile';

export const AppRoutes = () => {
	return (
		<BrowserRouter>
			<Routes>
				<Route path="/" element={<App />} />
				<Route path="profile" element={<Profile />} />
			</Routes>
		</BrowserRouter>
	);
};
