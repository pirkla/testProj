//
//  StartupStatus.swift
//  testProj
//
//  Created by Andrew Pirkl on 1/3/20.
//  Copyright © 2020 PIrklator. All rights reserved.
//

import Foundation
import os.log

struct StartupStatus: Codable{
    var step: String?
    var stepCode: StartupStepCode?
    var stepParam: String?
    var percentage: Int
    var warning: String?
    var warningCode: String?
    var warningParam: String?
    var error: String?
    var errorCode: StartupErrorCode?
    
    enum StartupStepCode: String, Codable{
        case SERVER_INIT_START, SERVER_INIT_ANALYZING_WEBAPP, SERVER_INIT_POPULATING_NAVIGATION, SERVER_INIT_POPULATING_OBJECTS, SERVER_INIT_INITIALIZING_OBJ, SERVER_INIT_VERIFYING_CACHE, SERVER_INIT_INITIALIZING_CHANGE_MANAGEMENT, SERVER_INIT_INITIALIZING_COMMUNICATION_SYSTEM, SERVER_INIT_INITIALIZING_MDM_QUEUE_MONITOR, SERVER_INIT_CALCULATING_SMART_GROUPS, SERVER_INIT_DB_SCHEMA_COMPARE, SERVER_INIT_DB_TABLE_CHECK_FOR_RENAME, SERVER_INIT_DB_TABLE_ALTER, SERVER_INIT_DB_TABLE_ANALYZING, SERVER_INIT_DB_TABLE_CREATE, SERVER_INIT_DB_TABLE_DROP, SERVER_INIT_DB_TABLE_RENAME, SERVER_INIT_DB_COLUMN_RENAME, SERVER_INIT_DB_COLUMN_ENCODING_CHANGE_STEP_1, SERVER_INIT_DB_COLUMN_ENCODING_CHANGE_STEP_2, SERVER_INIT_DB_COLUMN_ENCODING_CHANGE_STEP_3, SERVER_INIT_DB_UPGRADE_CHECK, SERVER_INIT_DB_UPGRADE_COMPLETE, SERVER_INIT_SS_GENERATE_NOTIFICATIONS, SERVER_INIT_SS_GENERATE_NOTIFICATIONS_STATUS, SERVER_INIT_SS_GENERATE_NOTIFICATIONS_FINALIZE, SERVER_INIT_PKI_MIGRATION_DONE, SERVER_INIT_PKI_MIGRATION_STATUS, SERVER_INIT_MEMCACHED_ENDPOINTS_CHECK, SERVER_INIT_CACHE_FLUSHING, SERVER_INIT_COMPLETE
    }
    enum StartupErrorCode: String, Codable{
        case CACHE_CONFIGURATION_ERROR, CHILD_NODE_STARTUP_ERROR, MORE_THAN_ONE_CLUSTER_SETTINGS_ERROR, MASTER_NODE_NOT_SET_ERROR, DATABASE_ERROR, DATABASE_PASSWORD_MISSING, EHCACHE_ERROR, FLAG_INITIALIZATION_FAILED, MEMCACHED_ERROR, DATABASE_MYISAM_ERROR
    }
}

extension StartupStatus {
    static func StartupStatusRequest(request: URLRequest, session: URLSession, completion: @escaping (Result<StartupStatus,Error>) -> Void) -> URLSessionDataTask {
        let dataTask = session.dataTask(request: request){
            (result) in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let responseObject = try decoder.decode(StartupStatus.self, from: data)
                    completion(.success(responseObject))
                }
                catch {
                    print(error)
                    completion(.failure(error))
                }
            case .failure(let error):
                os_log("Error returned: %@",log: .jamfAPI, type: .error,error.localizedDescription)
                completion(.failure(error))
            }
        }
        dataTask.resume()
        return dataTask
    }
}

