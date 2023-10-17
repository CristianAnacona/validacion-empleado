*** Settings ***
Library    RequestsLibrary
Library    String

*** Variables ***
${base_url}           https://reqres.in/api/users
${valid_name}         John
${valid_job}          Developer
${invalid_name}       # Dejar en blanco para simular un campo faltante
${invalid_job}        Tester

*** Test Cases ***
Crear Nuevo Empleado Exitosamente
    [Documentation]    Prueba para verificar la creación exitosa de un nuevo empleado.
    [Tags]    Create Employee
    Create Employee    ${valid_name}    ${valid_job}
    Verify Employee    ${valid_name}    ${valid_job}

Crear Nuevo Empleado con Campos Faltantes
    [Documentation]    Prueba para verificar la respuesta con campos faltantes.
    [Tags]    Create Employee
    Create Employee    ${invalid_name}    ${invalid_job}
    Verify Response Code    4..

*** Keywords ***
Create Employee
    [Arguments]    ${name}    ${job}
    ${headers}    Create Dictionary    Content-Type=application/json
    ${payload}    Create ictionary    name=${name}    job=${job}
    ${response}    Post Request    ${base_url}    json=${payload}    headers=${headers}
    Set Suite Variable    ${response}

Verify Employee
    [Arguments]    ${name}    ${job}
    ${json}    Convert To JSON    ${response.content}
    Should Be Equal As Strings    ${response.status_code}    201
    Should Be Greater Than    ${json.id}    0
    Should Be Equal As Strings    ${json.name}    ${name}
    Should Be Equal As Strings    ${json.job}    ${job}

Verify Response Code
    [Arguments]    ${expected_code}
    Should Start With    ${response.status_code}    ${expected_code}
