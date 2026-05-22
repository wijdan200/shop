import { User } from '../../domain/entities/User';

export interface UserModel extends User {
    // Can include DTO specific fields here if the API response is different from the Clean Domain Entity
    expires_in?: number;
}
