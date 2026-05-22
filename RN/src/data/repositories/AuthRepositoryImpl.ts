import { AuthRepository } from '../../domain/repositories/AuthRepository';
import { User } from '../../domain/entities/User';
import { AuthRemoteDataSource } from '../datasources/AuthRemoteDataSource';

export class AuthRepositoryImpl implements AuthRepository {
    constructor(private remoteDataSource: AuthRemoteDataSource) { }

    async login(email: string, password: string): Promise<User> {
        const userModel = await this.remoteDataSource.login(email, password);
        // Mapper can be used here to convert Model -> Entity if they differ significantly
        return {
            id: userModel.id,
            email: userModel.email,
            name: userModel.name,
            token: userModel.token,
        };
    }

    async logout(): Promise<void> {
        // Implement token clearing logic here
        return Promise.resolve();
    }
}
