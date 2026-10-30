using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class ButtonAudioComponent : MonoBehaviour, IPointerEnterHandler, IPointerClickHandler
{
    protected Button _button;

    private void Awake()
    {
        _button = GetComponent<Button>();
    }

    public void OnSelect(BaseEventData eventData)
    {
        if (!_button.IsInteractable()) return;

        AudioManager.instance.PlayOneShot("hover");
    }

    public void OnSubmit(BaseEventData eventData)
    {
        if (!_button.IsInteractable()) return;

        AudioManager.instance.PlayOneShot("click");
    }

    public void OnPointerEnter(PointerEventData eventData)
    {
        if (!_button.IsInteractable()) return;

        AudioManager.instance.PlayOneShot("hover");
    }

    public void OnPointerClick(PointerEventData eventData)
    {
        if (!_button.IsInteractable()) return;

        AudioManager.instance.PlayOneShot("click");
    }
}