import { UserModel } from '../models/UserModel';

export interface AuthRemoteDataSource {
    login(email: string, password: string): Promise<UserModel>;
}

export class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
    async login(email: string, password: string): Promise<UserModel> {
        // Simulate API Call delay
        return new Promise((resolve, reject) => {
            setTimeout(() => {
                if (email === 'test@test.com' && password === '123456') {
                    resolve({
                        id: '1',
                        email: 'test@test.com',
                        name: 'Test User',
                        token: 'mock_jwt_token_xyz_123',
                        expires_in: 3600,
                    });
                } else {
                    reject(new Error('Invalid email or password'));
                }
            }, 1500); // 1.5 seconds mock delay
        });
    }
}
