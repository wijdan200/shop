import { LoginUseCase } from '../../domain/usecases/LoginUseCase';
import { authStore$ } from '../state/authStore';

export class LoginViewModel {
    constructor(private loginUseCase: LoginUseCase) { }

    async login(email: string, password: string): Promise<void> {
        try {
            authStore$.isLoading.set(true);
            authStore$.error.set(null);

            const user = await this.loginUseCase.execute(email, password);

            authStore$.user.set(user);
        } catch (error: any) {
            authStore$.error.set(error.message || 'An error occurred during login');
        } finally {
            authStore$.isLoading.set(false);
        }
    }

    logout() {
        authStore$.user.set(null);
    }
}
