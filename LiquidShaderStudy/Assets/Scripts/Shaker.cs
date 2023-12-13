using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shaker : MonoBehaviour
{

    private Camera _mainCamera = null;
    private Ray pointerRay;

    // Start is called before the first frame update
    void Start()
    {
        if (GameObject.Find ("Main Camera").TryGetComponent<Camera>(out Camera cameraComponent))
            _mainCamera = cameraComponent;
        else
            Debug.Log("No Main Camera Found");
    }

    // Update is called once per frame
    void Update()
    {
        mousePosition();
    }

    void mousePosition()
    {
        pointerRay = Camera.main.ScreenPointToRay(Input.mousePosition);
        Vector3 worldPosition = Camera.main.ScreenToWorldPoint(Input.mousePosition);


        if(Physics.Raycast(ray: pointerRay, hitInfo: out RaycastHit hit) && hit.collider)
        {
            if(Input.GetMouseButton(0))
            {
                Debug.Log("Grabbed");
                transform.position = new Vector3(worldPosition.x, worldPosition.y, transform.position.z);
            }

        }
        
    }
}
