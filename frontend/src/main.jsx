import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import './styles/index.css';
import { AppRoutes } from './route/routes.jsx';

createRoot(document.getElementById('root')).render(
	<StrictMode>
		<AppRoutes />
	</StrictMode>,
);
